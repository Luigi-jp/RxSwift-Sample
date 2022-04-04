//
//  RxDataSourcesModel.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/04.
//

import Foundation
import RxDataSources

struct CharacterModel {
    var name: String
    var position: String
    var imageUrlStr: String
}

struct SectionData {
    var header: String
    var items: [Item]
}

extension SectionData: SectionModelType {
    typealias Item = CharacterModel
    
    init(original: SectionData, items: [Item]) {
            self = original
            self.items = items
        }
}
