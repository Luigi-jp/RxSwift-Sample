//
//  Router.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/24.
//

import UIKit

class Router {
    static let shared: Router = .init()
    private init(){}

    private var window: UIWindow?
    func showRoot(window: UIWindow) {
        let vc = RootViewController.makeFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }

    func showIncrementalSearch(from: UIViewController) {
        let vc = IncrementalSearchViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }

    func showSignup(from: UIViewController) {
        let vc = SignupViewController.makeFromStoryboard()
        show(from: from, to: vc)
    }
}

private extension Router {
    func show(from: UIViewController, to: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: animated)
        } else {
            from.present(to, animated: animated)
        }
    }
}
