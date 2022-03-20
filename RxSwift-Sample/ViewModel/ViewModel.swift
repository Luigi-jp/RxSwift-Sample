//
//  ViewModel.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/13.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol ViewModelInput {
    // Observer：イベント処理
    // イベントを受け付けるのみ？
    var searchTextObserver: AnyObserver<String> { get }
}

protocol ViewModelOutput {
    // Observable：イベント発生元
    // イベントを渡すのみ？
    var changeModelObservable: Observable<Void> { get }
    var models: [GithubModel] { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput, HasDisposeBag {
    

    // PublishRelay：イベントの検知と発生の両方ができるクラス
    private let _searchText = PublishRelay<String>()
    
    // Relayの場合、イベントを流すときonNextの代わりにacceptを使う。
    // 内部的にはonNextを呼んでいるため、特にonNextとacceptに違いはない。
    lazy var searchTextObserver: AnyObserver<String> = .init(eventHandler: { (event) in
        guard let e = event.element else { return }
        self._searchText.accept(e)
    })
    
    
    private let _changeModelObservable = PublishRelay<Void>()
    lazy var changeModelObservable: Observable<Void> = _changeModelObservable.asObservable()
    
    private (set) var models: [GithubModel] = []
    
    init() {
        _searchText.subscribe(onNext: { searchWord in
            GithubAPI.shared.rx.get(searchWord: searchWord)
                .map { [weak self] (models) -> Void in
                    self?.models = models
                    return
                }.bind(to: self._changeModelObservable).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
