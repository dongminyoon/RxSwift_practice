//
//  NetworkResult.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/17.
//

import Foundation

enum NetworkResult<Codable> {
    case success(data: Codable)
    case networkfail
}
