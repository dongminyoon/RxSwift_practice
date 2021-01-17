//
//  ViewModel.swift
//  RxSwift_3step
//
//  Created by 윤동민 on 2021/01/18.
//

import Foundation
import RxSwift

protocol ViewModelAble {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class ViewModel: ViewModelAble {
    struct Input {
        let userName = BehaviorSubject<String>(value: "")
    }
    
    struct Output {
        let gitRepository = BehaviorSubject<[GitRepository]>(value: [])
    }
    
    var input: Input
    var output: Output
    
    /* 서비스 요청하는 객체 */
    let githubService = GithubSearchService()
    
    init(input: Input = Input(),
         output: Output = Output()) {
        self.input = input
        self.output = output
        
        _ = input.userName
            .flatMapLatest { name -> Observable<[GitRepository]> in
                self.githubService.search(userName: name)
            }
            .bind(to: output.gitRepository)
    }
}
