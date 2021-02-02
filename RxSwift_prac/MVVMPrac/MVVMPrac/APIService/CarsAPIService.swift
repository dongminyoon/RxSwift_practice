//
//  CarsAPIService.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import Foundation
import RxSwift

protocol NetworkManagerProtocol {
    @discardableResult
    func request() -> URLSessionDataTask
}

final class NetworkManagerStub: NetworkManagerProtocol {
    var someValue: Int?

    func request() -> URLSessionDataTask {
        self.someValue = 10
        return URLSessionDataTask()
    }
}

class CarsAPIService {
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func requestCars() -> Observable<[Car]> {
        return Observable<[Car]>.create { [weak self] ob in
            // 만약 request가 외부 모듈로부터 Networking을 요청할 경우
            self?.networkManager.request()
            
            // 임시로 데이터
            var carsItem: [Car] = [
                Car(id: "1", make: "현대", model: "Avante", trim: "222"),
                Car(id: "2", make: "기아", model: "K5", trim: "333"),
                Car(id: "3", make: "BMW", model: "520d", trim: "4444"),
                Car(id: "4", make: "Mercedes-Benz", model: "C class", trim: "5555"),
                Car(id: "5", make: "기아", model: "K3", trim: "6666")
            ]
            
            carsItem.shuffle()
            ob.onNext(carsItem)
            ob.onCompleted()
            
            return Disposables.create()
        }
    }
}

