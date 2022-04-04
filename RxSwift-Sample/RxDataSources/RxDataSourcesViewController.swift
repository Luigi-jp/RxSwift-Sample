//
//  RxDataSourcesViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/04.
//

import UIKit

class RxDataSourcesViewController: UIViewController {
    static func makeFromStoryboard() -> RxDataSourcesViewController {
        let vc = UIStoryboard.rxDataSourcesViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
