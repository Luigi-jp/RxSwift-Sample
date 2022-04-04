//
//  UIStoryboard+.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/24.
//

import UIKit

extension UIStoryboard {
    static var rootViewController: RootViewController {
        UIStoryboard.init(name: "Root", bundle: nil).instantiateInitialViewController() as! RootViewController
    }

    static var incrementalSearchViewController: IncrementalSearchViewController {
        UIStoryboard.init(name: "IncrementalSearch", bundle: nil).instantiateInitialViewController() as! IncrementalSearchViewController
    }

    static var signupViewController: SignupViewController {
        UIStoryboard.init(name: "Signup", bundle: nil).instantiateInitialViewController() as! SignupViewController
    }

    static var greetingViewController: GreetingViewController {
        UIStoryboard.init(name: "Greeting", bundle: nil).instantiateInitialViewController() as! GreetingViewController
    }

    static var rxDataSourcesViewController: RxDataSourcesViewController {
        UIStoryboard.init(name: "RxDataSources", bundle: nil).instantiateInitialViewController() as! RxDataSourcesViewController
    }
}
