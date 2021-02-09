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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.isHidden = true
        }
    }
    
    var disposeBag = DisposeBag()
    var searchViewModel: SearchViewModelType
    
    init(searchViewModel: SearchViewModelType) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.searchViewModel = SearchViewModel()
        super.init(coder: aDecoder)
    }
    
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
        navigationItem.searchController?.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: searchViewModel.userName)
            .disposed(by: disposeBag)
        
        searchViewModel.searching
            .subscribe(onNext: { [weak self] searching in
                if searching {
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        searchViewModel.gitRepository
            .asDriver(onErrorJustReturn: [])
            .drive(resultTableView.rx.items) { tableView, index, item -> UITableViewCell in
                guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as? CustomCell else { return UITableViewCell() }
                customCell.titleLabel.text = item.full_name
                return customCell
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
