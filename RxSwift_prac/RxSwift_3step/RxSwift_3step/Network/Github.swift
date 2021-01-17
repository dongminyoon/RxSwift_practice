//
//  SessionResources.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/17.
//

import Foundation
import Moya

extension String {
    var escapingUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}

enum Github {
    case userRepo(name: String)
}

extension Github: TargetType {
    /* 통신을 위한 Base URL */
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    /* HTTP 요청의 리소스 위치 */
    var path: String {
        switch self {
        case .userRepo(let name): return "/users/\(name.escapingUrl)/repos"
        }
    }
    
    /* 요청할 때, HTTP 통신의 Method 정의 */
    var method: Moya.Method {
        switch self {
        case .userRepo: return .get
        }
    }
    
    /*
     Unit Test를 위해 사용될 수 있다.
     네트워킹 요청대신, 가짜 객체를 반환하게 할 수 있는 것
     */
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /* 각 요청별 어떤 request 형태로 보낼지 */
    var task: Task {
        switch self {
        default: return .requestPlain
        }
    }
    
    /* 각 요청별로 넣어보낼 Header */
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    /* 200번대의 코드에만 성공으로 간주 */
    var validationType: ValidationType {
        return .successCodes
    }
}
