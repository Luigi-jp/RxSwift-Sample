//
//  TableViewCell.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/04.
//

import UIKit

final class TableViewCell: UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var positionLable: UILabel!

    override func prepareForReuse() {
        characterImageView.image = nil
        nameLabel.text = nil
        positionLable.text = nil
    }

    func configure(item: CharacterModel) {
        characterImageView.loadImage(with: item.imageUrlStr)
        nameLabel.text = item.name
        positionLable.text = item.position
    }
}
