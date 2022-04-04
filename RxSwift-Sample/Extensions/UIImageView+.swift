//
//  UIImageView+.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/05.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        loadImage(with: url)
    }
    
    func loadImage(with url: URL) {
        Nuke.loadImage(with: url ,into: self)
    }
}
