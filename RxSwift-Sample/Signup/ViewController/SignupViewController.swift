//
//  SignupViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/25.
//

import UIKit

class SignupViewController: UIViewController {
    static func makeFromStoryboard() -> SignupViewController {
        let vc = UIStoryboard.signupViewController
        return vc
    }

    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userNameValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var passwordConfirmValidationLabel: UILabel!
    @IBOutlet private weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
