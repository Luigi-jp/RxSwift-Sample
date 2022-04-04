//
//  RxDataSourcesPresenter.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/04.
//

import Foundation
import RxSwift
import RxDataSources

final class RxDataSourcesPresenter {
    
    let characters = Observable.just([
        SectionData(header: "秦", items: [
            CharacterModel(name: "嬴政", position: "国王", imageUrlStr: "https://youngjump.jp/kingdom/character/images/shin/01.jpg"),
            CharacterModel(name: "信", position: "五千人将", imageUrlStr: "https://youngjump.jp/kingdom/character/images/shin/09.jpg"),
            CharacterModel(name: "羌瘣", position: "三千人将", imageUrlStr: "https://youngjump.jp/kingdom/character/images/shin/11.jpg"),
        ]),
        SectionData(header: "趙", items: [
            CharacterModel(name: "李牧", position: "宰相", imageUrlStr: "https://youngjump.jp/kingdom/character/images/cho/01.jpg"),
            CharacterModel(name: "龐煖", position: "三大天", imageUrlStr: "https://youngjump.jp/kingdom/character/images/cho/02.jpg"),
            CharacterModel(name: "慶舎", position: "将軍", imageUrlStr: "https://youngjump.jp/kingdom/character/images/cho/03.jpg"),
        ]),
        SectionData(header: "魏", items: [
            CharacterModel(name: "呉鳳明", position: "大将軍", imageUrlStr: "https://youngjump.jp/kingdom/character/images/gi/01.jpg"),
            CharacterModel(name: "乱美追", position: "武将", imageUrlStr: "https://youngjump.jp/kingdom/character/images/gi/06.jpg"),
            CharacterModel(name: "輪虎", position: "将軍", imageUrlStr: "https://youngjump.jp/kingdom/character/images/gi/09.jpg"),
        ]),
    ])
}
