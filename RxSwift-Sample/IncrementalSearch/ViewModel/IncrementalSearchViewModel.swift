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

protocol IncrementalSearchViewModelInput {
    // Observer：イベント処理
    // イベントを受け付けるのみ？
    var searchTextObserver: AnyObserver<String> { get }
    var sortTypeObserver: AnyObserver<Bool> { get }
}

protocol IncrementalSearchViewModelOutput {
    // Observable：イベント発生元
    // イベントを渡すのみ？
    var changeModelObservable: Observable<Void> { get }
    var models: [GithubModel] { get }
}

final class IncrementalSearchViewModel: IncrementalSearchViewModelInput, IncrementalSearchViewModelOutput, HasDisposeBag {
    

    // PublishRelay：イベントの検知と発生の両方ができるクラス
    private let _searchText = PublishRelay<String>()
    
    // Relayの場合、イベントを流すときonNextの代わりにacceptを使う。
    // 内部的にはonNextを呼んでいるため、特にonNextとacceptに違いはない。
    lazy var searchTextObserver: AnyObserver<String> = .init(eventHandler: { (event) in
        guard let e = event.element else { return }
        self._searchText.accept(e)
    })

    private let _sortType = PublishRelay<Bool>()
    lazy var sortTypeObserver: AnyObserver<Bool> = .init(eventHandler: { event in
        guard let e = event.element else { return }
        self._sortType.accept(e)
    })
    
    
    private let _changeModelObservable = PublishRelay<Void>()
    lazy var changeModelObservable: Observable<Void> = _changeModelObservable.asObservable()
    
    private (set) var models: [GithubModel] = []
    
    init() {
        Observable.combineLatest(_searchText, _sortType)
            .flatMapLatest { (searchWord, sortType) -> Observable<[GithubModel]> in
                GithubAPI.shared.rx.get(searchWord: searchWord, isDesc: sortType)
            }.map { [weak self] (models) -> Void in
                self?.models = models
                return
            }.bind(to: _changeModelObservable).disposed(by: disposeBag)
    }
}
