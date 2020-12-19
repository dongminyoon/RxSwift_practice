//
//  ViewController.swift
//  RxSwift_2step
//
//  Created by 윤동민 on 2020/11/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let randomGenerator = Observable<Int>.create { ob in
            ob.onNext(Int.random(in: 0...100))
            ob.onCompleted()
            return Disposables.create()
        }
        
        randomGenerator.subscribe(onNext: { ranNum in
            print("ob1 : \(ranNum)")
        })
        .dispose()
        
        randomGenerator.subscribe(onNext: { ranNum in
            print("ob2 : \(ranNum)")
        })
        .dispose()
    }


}

