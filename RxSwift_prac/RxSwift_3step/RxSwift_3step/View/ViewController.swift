//
//  ViewController.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/16.
//

import UIKit
import Moya

class ViewController: UIViewController {
    @IBOutlet weak var resultTableView: UITableView!
    
    private let gitSearchService = GithubSearchService()
    
    var cancellableBag: [Cancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let searchController = UISearchController(searchResultsController: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        navigationItem.title = "Github Search"

        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        if indexPath.row % 2 == 0 {
            customCell.backgroundColor = .red
        } else {
            customCell.backgroundColor = .yellow
        }
        return customCell
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let cancellable = gitSearchService.search(userName: searchText) { result in
            print(result)
        }
        
        cancellableBag.append(cancellable)
    }
}
