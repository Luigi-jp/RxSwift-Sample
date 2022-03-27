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
    var passwordObserver: AnyObserver<String> { get }
    var passwordConfirmObserver: AnyObserver<String> { get }
}

protocol SignupViewModelOutput {
    var usernameValidateObservable: Observable<Bool> { get }
    var passwordValidateObservable: Observable<Bool> { get }
    var passwordConfirmValidateObservable: Observable<Bool> { get }
}

final class SignupViewModel: SignupViewModelInput, SignupViewModelOutput, HasDisposeBag {
    private let usernameRelay = PublishRelay<String>()
    lazy var usernameObserver: AnyObserver<String> = .init { event in
        guard let e = event.element else { return }
        self.usernameRelay.accept(e)
    }
    private let passwordRelay = PublishRelay<String>()
    lazy var passwordObserver: AnyObserver<String> = .init { event in
        guard let e = event.element else { return }
        self.passwordRelay.accept(e)
    }
    private let passwordConfirmRelay = PublishRelay<String>()
    lazy var passwordConfirmObserver: AnyObserver<String> = .init { event in
        guard let e = event.element else { return }
        self.passwordConfirmRelay.accept(e)
    }

    private let usernameValidateRelay = BehaviorRelay<Bool>(value: true)
    lazy var usernameValidateObservable: Observable<Bool> = usernameValidateRelay.asObservable()
    private let passwordValidateRelay = BehaviorRelay<Bool>(value: true)
    lazy var passwordValidateObservable: Observable<Bool> = passwordValidateRelay.asObservable()
    private let passwordConfirmValidateRelay = BehaviorRelay<Bool>(value: true)
    lazy var passwordConfirmValidateObservable: Observable<Bool> = passwordConfirmValidateRelay.asObservable()

    init() {
        usernameRelay.subscribe(onNext: { username in
            self.usernameValidate(username: username)
                .bind(to: self.usernameValidateRelay)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        passwordRelay.subscribe(onNext: { password in
            self.passwordValidate(password: password)
                .bind(to: self.passwordValidateRelay)
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        Observable.combineLatest(passwordRelay, passwordConfirmRelay)
            .flatMapLatest { (password, confirm) -> Observable<Bool> in
                self.passwordConfirmValidate(password: password, confirm: confirm)
            }
            .bind(to: passwordConfirmValidateRelay)
            .disposed(by: disposeBag)
    }
    
    func usernameValidate(username: String) -> Observable<Bool> {
      return Observable.create { observer in
          observer.on(.next(username.count > 5))
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }

    func passwordValidate(password: String) -> Observable<Bool> {
      return Observable.create { observer in
          observer.on(.next(password.count > 7))
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }

    func passwordConfirmValidate(password: String, confirm: String) -> Observable<Bool> {
      return Observable.create { observer in
          observer.on(.next(password == confirm))
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }
    
}

