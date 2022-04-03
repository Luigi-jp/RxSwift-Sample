//
//  GreetingViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/03.
//

import UIKit

final class GreetingViewController: UIViewController {
    static func makeFromStoryboard() -> GreetingViewController {
        let vc = UIStoryboard.greetingViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
