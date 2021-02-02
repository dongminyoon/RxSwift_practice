//
//  DetailCarViewController.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import UIKit
import RxCocoa
import RxSwift

class DetailCarViewController: UIViewController {
    static let identifier = "DetailCarViewController"

    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    
    let viewModel = CarDetailViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindUI()
    }
    
    func bindUI() {
        viewModel.output.make
            .subscribe(onNext: { [weak self] make in
                self?.makeLabel.text = make
            })
            .disposed(by: disposeBag)
        
        viewModel.output.model
            .subscribe(onNext: { [weak self] model in
                self?.modelLabel.text = model
            })
            .disposed(by: disposeBag)
    }
}
