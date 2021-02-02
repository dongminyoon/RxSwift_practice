//
//  CarViewModel.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import Foundation
import RxSwift
import RxRelay

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class CarViewModel: ViewModelType {
    struct Input {
        let reloadTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let carsList = BehaviorRelay<[Car]>(value: [])
        let refreshing = BehaviorSubject<Bool>(value: false)
    }
    
    var input: Input
    var output: Output
    
    let apiService: CarsAPIService
    var disposeBag = DisposeBag()
    
    init(input: Input = Input(),
         output: Output = Output(),
         apiService: CarsAPIService = CarsAPIService(networkManager: NetworkManagerStub())) {
        self.input = input
        self.output = output
        self.apiService = apiService
        
        
        setReloadTrigger()
    }
    
    func fetchCars() {
        apiService.requestCars()
            .subscribe { [weak self] in
                self?.output.carsList.accept($0)
            }
            .disposed(by: disposeBag)
    }
    
    private func setReloadTrigger() {
        self.input.reloadTrigger
            .do(onNext: { [weak self] in self?.output.refreshing.onNext(true)})
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] in
                (self?.apiService.requestCars())!
            }
            .do(onNext: { [weak self] _ in self?.output.refreshing.onNext(false) })
            .bind(to: self.output.carsList)
            .disposed(by: disposeBag)
    }
    
}
