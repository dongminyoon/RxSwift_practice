//
//  SearchViewModelTests.swift
//  RxSwift_3stepTests
//
//  Created by USER on 2021/02/08.
//

import XCTest

@testable import RxSwift_3step
@testable import RxSwift

final class GithubSearchServiceMock: GithubSearchServiceProtocol {
    var searchParameter: String?
    
    func searchRepos(of userName: String) -> Observable<[GitRepository]> {
        self.searchParameter = userName
        
        return Observable.create() { observer in
            observer.onNext([])
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

class SearchViewModelTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SearchUserRepo() {
        // given
        let githubSearchServiceMock = GithubSearchServiceMock()
        let viewModel = SearchViewModel(githubSearchService: githubSearchServiceMock)
        let searchKeyword: String = "dongmin"
        
        // when
        viewModel.userName.onNext(searchKeyword)
        
        // then
        XCTAssertEqual(githubSearchServiceMock.searchParameter, searchKeyword, "Keyword was wrong")
    }
    
    func test_Searching() {
        let githubSearchServiceMock = GithubSearchServiceMock()
        let viewModel = SearchViewModel(githubSearchService: githubSearchServiceMock)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            viewModel.userName.onNext("dongmin")
            viewModel.searching.onCompleted()
        })
        
        let result = try? viewModel.searching.toBlocking().toArray()
        
        XCTAssertEqual(result, [true, false], "Test Failed")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
