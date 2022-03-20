//
//  TableViewCell.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/13.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!

    func configure(model: GithubModel) {
        titleLabel.text = model.name
        urlLabel.text = model.urlStr
    }
}
