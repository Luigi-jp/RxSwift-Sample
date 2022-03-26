//
//  SingupViewModel.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/25.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol SignupViewModelInput {
    var usernameObserver: AnyObserver<String> { get }
}

protocol SignupViewModelOutput {
    var usernameValidateObservable: Observable<Bool> { get }
}

final class SignupViewModel: SignupViewModelInput, SignupViewModelOutput, HasDisposeBag {
    private let usernameRelay = PublishRelay<String>()
    lazy var usernameObserver: AnyObserver<String> = .init { event in
        guard let e = event.element else { return }
        self.usernameRelay.accept(e)
    }

    private let usernameValidateRelay = BehaviorRelay<Bool>(value: true)
    lazy var usernameValidateObservable: Observable<Bool> = usernameValidateRelay.asObservable()

    init() {
        usernameRelay.subscribe(onNext: { username in
            self.usernameValidate(username: username)
                .bind(to: self.usernameValidateRelay)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    func usernameValidate(username: String) -> Observable<Bool> {
      return Observable.create { observer in
          observer.on(.next(username.count > 5))
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }
}

