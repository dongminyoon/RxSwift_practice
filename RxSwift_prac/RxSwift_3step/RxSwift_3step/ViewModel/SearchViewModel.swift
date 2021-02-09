//
//  ViewModel.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/18.
//

import Foundation
import RxSwift
import Moya

protocol SearchViewModelType {
    // Input
    var userName: BehaviorSubject<String> { get }

    // Output
    var gitRepository: BehaviorSubject<[GitRepository]> { get }
    var searching: PublishSubject<Bool> { get }
    
    var githubService: GithubSearchServiceProtocol { get set }
}

class SearchViewModel: SearchViewModelType {
    // Input
    var userName: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    // Output
    var gitRepository: BehaviorSubject<[GitRepository]> = BehaviorSubject<[GitRepository]>(value: [])
    var searching: PublishSubject<Bool> = PublishSubject<Bool>()
    
    var disposeBag = DisposeBag()

    /* 서비스 요청하는 객체 */
    var githubService: GithubSearchServiceProtocol

    init(githubSearchService: GithubSearchServiceProtocol = GithubSearchService()) {
        self.githubService = githubSearchService

        _ = userName
            .do(onNext: { [weak self] _ in self?.searching.onNext(true) })
            .flatMapLatest { name -> Observable<[GitRepository]> in
                return self.githubService.searchRepos(of: name)
            }
            .do(onNext: { [weak self] _ in self?.searching.onNext(false) })
            .bind(to: gitRepository)
    }
}
