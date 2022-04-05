//
//  GithubAPI.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/13.
//

import Foundation
import RxSwift
import Alamofire

final class GithubAPI {
    static let shared: GithubAPI = GithubAPI()
    private init() {}

    func get(searchWord: String, isDesc: Bool = true, success: (([GithubModel]) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        guard searchWord.count > 0 else {
            success?([])
            return
        }
        AF.request("https://api.github.com/search/repositories?q=\(searchWord)&sort=stars&order=\(isDesc ? "desc" : "asc")").response { response in
            switch response.result {
            case .success:
                guard let data = response.data,
                      let githubResponse = try? JSONDecoder().decode(GithubResponse.self, from: data),
                      let models = githubResponse.items
                else {
                    success?([])
                    return
                }
                success?(models)
            case .failure(let error):
                failure?(error)
            }
        }
    }
}

extension GithubAPI: ReactiveCompatible {}
extension Reactive where Base: GithubAPI {
    func get(searchWord: String, isDesc: Bool = true) -> Observable<[GithubModel]> {
      return Observable.create { observer in
          GithubAPI.shared.get(searchWord: searchWord, isDesc: isDesc, success: { model in
              observer.on(.next(model))
          }, failure: { error in
              observer.on(.error(error))
          })
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }
}
