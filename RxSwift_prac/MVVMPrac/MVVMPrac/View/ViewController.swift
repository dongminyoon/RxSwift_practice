//
//  ViewController.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CarViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTableView()
        bindTableView()
        
        viewModel.fetchCars()
    }

    func setTableView() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.reloadTrigger)
            .disposed(by: disposeBag)
        
        self.viewModel.output.refreshing
            .subscribe(onNext: { [weak self] refreshing in
                if refreshing { return }
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        viewModel.output.carsList
            .bind(to: tableView.rx.items) { tableView, indexPath, item in
                guard let carCell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier) as? CarCell else { return UITableViewCell() }
                let carDTO = item.makeCarDTO()
                carCell.configure(from: carDTO)
                return carCell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                guard let carDetailVC = UIComponents.mainStoryboard.instantiateViewController(withIdentifier: DetailCarViewController.identifier) as? DetailCarViewController else { return }

                let selectedCar = self.viewModel.output.carsList.value[indexPath.row]
                carDetailVC.viewModel.input.carInform.onNext(selectedCar)

                self.navigationController?.pushViewController(carDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
