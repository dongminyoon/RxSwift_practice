//
//  NetworkHandler.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/17.
//

import Foundation
import Moya
import RxSwift

typealias Handler = ((NetworkResult<Codable>) -> Void)

final class GithubSearchService {
    private let provider: MoyaProvider<SessionResources>

    init(provider: MoyaProvider<SessionResources> = MoyaProvider<SessionResources>()) {
        self.provider = provider
    }
    
    func search(userName: String, completion: @escaping Handler) -> Cancellable {
        return provider.request(.userRepo(name: userName)) { result in
            switch result {
            case .success(let response):
                print(response.response?.statusCode)
                print(response.data)
                print(try? response.mapJSON())
            case .failure(let error):
                print(error.errorCode)
                print(error.localizedDescription)
            }
        }
    }
}
