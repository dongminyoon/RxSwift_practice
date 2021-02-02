//
//  CarDetailViewModel.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import Foundation
import RxSwift

class CarDetailViewModel: ViewModelType {
    struct Input {
        let carInform = BehaviorSubject<Car?>(value: nil)
    }
    
    struct Output {
        var make: Observable<String>
        var model: Observable<String>
    }
    
    var input: Input
    var output: Output
    
    init() {
        self.input = Input()
        
        let make = self.input.carInform
            .filter { $0 != nil }
            .map { $0!.make }
        
        let model = self.input.carInform
            .filter { $0 != nil }
            .map { $0!.model }
        
        self.output = Output(make: make,
                             model: model)
    }
}
