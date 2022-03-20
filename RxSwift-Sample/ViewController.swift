//
//  ViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class ViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = ViewModel()
    private lazy var input: ViewModelInput = viewModel
    private lazy var output: ViewModelOutput = viewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        bindInputStream()
        bindOutputStream()
    }
    
    private func bindInputStream() {
        let searchTextObservable = searchBar.searchTextField.rx.text
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filterNil()
            .filter { $0.isNotEmpty }
        
        // input側のObserverにストリームを接続する（流す）
        // subscribeと同じ振る舞い
        searchTextObservable.bind(to: input.searchTextObserver).disposed(by: rx.disposeBag)
    }
    
    private func bindOutputStream() {
        output.changeModelObservable.subscribe(on: MainScheduler.instance).subscribe(onNext: {
            self.tableView.reloadData()
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            fatalError()
        }
        let item = output.models[indexPath.row]
        cell.configure(model: item)
        return cell
    }
}
