//
//  ViewController.swift
//  RxSwift_1step
//
//  Created by 윤동민 on 2020/10/18.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    var shownCities: [String] = []
    let allCities: [String] = ["Seoul", "Suwon", "ChangWon", "Masan", "Busan", "CheongJu", "KwangJu"]

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                if text.isEmpty { self.shownCities = self.allCities }
                else { self.shownCities = self.allCities.filter({ $0.contains(text) }) }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}

