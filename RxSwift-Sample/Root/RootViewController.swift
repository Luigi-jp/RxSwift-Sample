//
//  RootViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/24.
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    static func makeFromStoryboard() -> RootViewController {
        let vc = UIStoryboard.rootViewController
        return vc
    }

    @IBOutlet private weak var incrementalSearchButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var greetingButton: UIButton!
    @IBOutlet private weak var rxDataSourcesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incrementalSearchButton.rx.tap.subscribe(onNext: {
            Router.shared.showIncrementalSearch(from: self)
        }).disposed(by: rx.disposeBag)

        signupButton.rx.tap.subscribe(onNext: {
            Router.shared.showSignup(from: self)
        }).disposed(by: rx.disposeBag)

        greetingButton.rx.tap.subscribe(onNext: {
            Router.shared.showGreeting(from: self)
        }).disposed(by: rx.disposeBag)
    
        rxDataSourcesButton.rx.tap.subscribe(onNext: {
            Router.shared.showRxDataSources(from: self)
        }).disposed(by: rx.disposeBag)
    }
}
