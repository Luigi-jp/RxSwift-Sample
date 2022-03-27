//
//  SignupViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class SignupViewController: UIViewController {
    static func makeFromStoryboard() -> SignupViewController {
        let vc = UIStoryboard.signupViewController
        return vc
    }

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var passwordConfirmValidationLabel: UILabel!
    @IBOutlet private weak var signupButton: UIButton!
    
    private let viewModel = SignupViewModel()
    private lazy var input: SignupViewModelInput = viewModel
    private lazy var output: SignupViewModelOutput = viewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        bindInputStream()
        bindOutputStream()
    }

    private func bindInputStream() {
        let usernameObservable = usernameTextField.rx.text.asObservable()
            .filterNil()
            .filter{ $0.isNotEmpty }
        usernameObservable.bind(to: input.usernameObserver).disposed(by: rx.disposeBag)
        let passwordObservable = passwordTextField.rx.text.asObservable()
            .filterNil()
            .filter{ $0.isNotEmpty }
        passwordObservable.bind(to: input.passwordObserver).disposed(by: rx.disposeBag)
        let passwordConfirmObservable = passwordConfirmTextField.rx.text.asObservable()
            .filterNil()
            .filter{ $0.isNotEmpty }
        passwordConfirmObservable.bind(to: input.passwordConfirmObserver).disposed(by: rx.disposeBag)
    }

    private func bindOutputStream() {
        output.usernameValidateObservable.subscribe(onNext: { valid in
            self.usernameValidationLabel.isHidden = valid
        }).disposed(by: rx.disposeBag)
        output.passwordValidateObservable.subscribe(onNext: { valid in
            self.passwordValidationLabel.isHidden = valid
        }).disposed(by: rx.disposeBag)
        output.passwordConfirmValidateObservable.subscribe(onNext: { valid in
            self.passwordConfirmValidationLabel.isHidden = valid
        }).disposed(by: rx.disposeBag)
    }
}
