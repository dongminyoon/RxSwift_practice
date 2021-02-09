//
//  GitRepository.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/17.
//

import Foundation

struct GitRepository: Codable {
    let full_name: String

    enum CodingKeys: String, CodingKey {
        case full_name = "full_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        full_name = try values.decode(String.self, forKey: .full_name)
    }
    
    init(full_name: String) {
        self.full_name = full_name
    }
}
