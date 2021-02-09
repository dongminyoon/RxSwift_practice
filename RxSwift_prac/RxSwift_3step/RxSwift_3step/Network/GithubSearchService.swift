//
//  NetworkHandler.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/17.
//

import Foundation
import Moya
import RxSwift

protocol GithubSearchServiceProtocol {
    func searchRepos(of userName: String) -> Observable<[GitRepository]>
}

final class GithubSearchService: GithubSearchServiceProtocol {
    private let provider: MoyaProvider<Github>

    init(provider: MoyaProvider<Github> = MoyaProvider<Github>()) {
        self.provider = provider
    }
    
    func searchRepos(of userName: String) -> Observable<[GitRepository]> {
        if userName == "" { return Observable.create() { ob in
            ob.onNext([])
            ob.onCompleted()
            return Disposables.create()
        }
        }
        return Observable.create() { [weak self] ob in
            self?.provider.request(.userRepo(name: userName)) { result in
                switch result {
                case .success(let response):
                    let decoder = try? JSONDecoder().decode([GitRepository].self, from: response.data)
                    ob.onNext(decoder ?? [])
                case .failure(let error):
                    print(error)
                    ob.onNext([])
                }
                
                ob.onCompleted()
            }
            return Disposables.create()
        }
    }
}
