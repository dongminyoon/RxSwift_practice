//
//  ViewModel.swift
//  RxSwift_2step
//
//  Created by 윤동민 on 2020/12/20.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class ViewModel: ViewModelType {
    var input: Input
    var output: Output
    
    struct Input {
        var circlePoint = PublishSubject<CGPoint?>()
    }
    
    struct Output {
        var backgroundColor: Observable<UIColor>
    }
    
    init() {
        input = Input()
        
        let transColor = input.circlePoint
            .map { center -> UIColor in
                guard let center = center else { return .black }
                
                let red = (center.x + center.y).truncatingRemainder(dividingBy: 255.0)/255.0
                let green = 0.0
                let blue = 0.0
                
                return UIColor(red: red, green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
            }
        
        output = Output(backgroundColor: transColor)
    }
}
