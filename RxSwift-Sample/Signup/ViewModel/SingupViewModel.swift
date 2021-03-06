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

enum ValidationResult {
    case ok
    case empty
    case usernameFailed
    case passwordFailed
    case passwordConfirmFailed

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }

    var validationText: String {
        switch self {
        case .usernameFailed:
            return "ユーザー名は6文字以上で入力してください"
        case .passwordFailed:
            return "パスワードは8文字以上で入力してください"
        case .passwordConfirmFailed:
            return "パスワードが一致しません。"
        default:
            return ""
        }
    }
}

protocol SignupViewModelInput {
    var usernameObserver: AnyObserver<String> { get }
    var passwordObserver: AnyObserver<String> { get }
    var passwordConfirmObserver: AnyObserver<String> { get }
    var signedupObserver: AnyObserver<Void> { get }
}

protocol SignupViewModelOutput {
    var usernameValidateObservable: Observable<ValidationResult> { get }
    var passwordValidateObservable: Observable<ValidationResult> { get }
    var passwordConfirmValidateObservable: Observable<ValidationResult> { get }
    var signupEnabledObservable: Observable<Bool> { get }
    var signedupResultObservable: Observable<Bool> { get }
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
    private let signedupRelay = PublishRelay<Void>()
    lazy var signedupObserver: AnyObserver<Void> = .init { event in
        guard let e = event.element else { return }
        self.signedupRelay.accept(e)
    }

    private let usernameValidateRelay = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var usernameValidateObservable: Observable<ValidationResult> = usernameValidateRelay.asObservable()
    private let passwordValidateRelay = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var passwordValidateObservable: Observable<ValidationResult> = passwordValidateRelay.asObservable()
    private let passwordConfirmValidateRelay = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var passwordConfirmValidateObservable: Observable<ValidationResult> = passwordConfirmValidateRelay.asObservable()
    private let signupEnabledRelay = BehaviorRelay<Bool>(value: false)
    lazy var signupEnabledObservable: Observable<Bool> = signupEnabledRelay.asObservable()
    private let signedupResultRelay = PublishRelay<Bool>()
    lazy var signedupResultObservable: Observable<Bool> = signedupResultRelay.asObservable()

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
            .flatMapLatest { (password, confirm) -> Observable<ValidationResult> in
                self.passwordConfirmValidate(password: password, confirm: confirm)
            }
            .bind(to: passwordConfirmValidateRelay)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            usernameValidateObservable,
            passwordValidateObservable,
            passwordConfirmValidateObservable
        ) { username, password, confirmPassword in
            username.isValid &&
            password.isValid &&
            confirmPassword.isValid
        }
        .share(replay: 1, scope: .whileConnected)
        .bind(to: signupEnabledRelay)
        .disposed(by: disposeBag)

        let usernameAndPassword = Observable.combineLatest(usernameRelay, passwordRelay) { (username: $0, password: $1) }
        signedupRelay.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair -> Observable<Bool> in
                self.signup(pair.username, password: pair.password)
        }
        .share(replay: 1, scope: .whileConnected)
        .bind(to: signedupResultRelay)
        .disposed(by: disposeBag)
    }
}

private extension SignupViewModel {
    func usernameValidate(username: String) -> Observable<ValidationResult> {
      return Observable.create { observer in
          let numberOfCharacters = username.count
          if numberOfCharacters == 0 {
              observer.on(.next(.empty))
          } else if numberOfCharacters > 5 {
              observer.on(.next(.ok))
          } else {
              observer.on(.next(.usernameFailed))
          }
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }

    func passwordValidate(password: String) -> Observable<ValidationResult> {
      return Observable.create { observer in
          let numberOfCharacters = password.count
          if numberOfCharacters == 0 {
              observer.on(.next(.empty))
          } else if numberOfCharacters > 7 {
              observer.on(.next(.ok))
          } else {
              observer.on(.next(.passwordFailed))
          }
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }

    func passwordConfirmValidate(password: String, confirm: String) -> Observable<ValidationResult> {
      return Observable.create { observer in
          if confirm.count == 0 {
              observer.on(.next(.empty))
          } else if password == confirm {
              observer.on(.next(.ok))
          } else {
              observer.on(.next(.passwordConfirmFailed))
          }
          return Disposables.create()
      }.share(replay: 1, scope: .whileConnected)
    }

    func signup(_ username: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
