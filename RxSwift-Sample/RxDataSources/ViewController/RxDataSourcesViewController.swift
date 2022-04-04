//
//  RxDataSourcesViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class RxDataSourcesViewController: UIViewController {
    static func makeFromStoryboard() -> RxDataSourcesViewController {
        let vc = UIStoryboard.rxDataSourcesViewController
        return vc
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    let charactersData = RxDataSourcesPresenter()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionData>(
        configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(item: item)
        return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].header
        }
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        
        charactersData.characters.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        
    }
}
