//
//  Car.swift
//  MVVMPrac
//
//  Created by USER on 2021/02/02.
//

import Foundation

struct Car {
    let id: String
    let make: String
    let model: String
    let trim: String
    
    func makeCarDTO() -> CarDTO {
        return CarDTO(make: self.make,
                      model: self.model)
    }
}

struct CarDTO {
    let make: String
    let model: String
}
