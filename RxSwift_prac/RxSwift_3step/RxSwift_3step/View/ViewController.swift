//
//  ViewController.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/16.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var resultTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initSearchBar()
        
        setRx()
        bindTableView()
    }
    
    private func initSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.title = "Github Search"
    }
    
    private func setRx() {
        navigationItem.searchController?.searchBar.rx
            .text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.userName)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.output.gitRepository
            .asDriver(onErrorJustReturn: [])
            .drive(resultTableView.rx.items) { tableView, index, item -> UITableViewCell in
                guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell else { return UITableViewCell() }
                customCell.titleLabel.text = item.full_name
                return customCell
            }
            .disposed(by: disposeBag)
    }
}
