//
//  GithubSearchTests.swift
//  RxSwift_3stepTests
//
//  Created by USER on 2021/02/08.
//

import XCTest
@testable import Moya
@testable import RxSwift_3step

final class ProviderMock: MoyaProvider<Github> {
    var networkMaterial: (url: URL,
                          method: Moya.Method,
                          header: [String: String])?

    override func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        var baseURL = target.baseURL
        baseURL.appendPathComponent(target.path)
        self.networkMaterial = (
            url: baseURL,
            method: target.method,
            header: target.headers!
        )
        return SimpleCancellable()
    }
}

class GithubSearchTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_RequestUserRepo() {
        // given
        let providerMock = ProviderMock()
        let githubSearchService = GithubSearchService(provider: providerMock)
        let repoName = "dongmin"
        
        let correctURL = "https://api.github.com/users/\(repoName)/repos"
        let correctMethod = Moya.Method.get
        let correctHeader = ["Content-Type": "application/json"]
        
        // when
        githubSearchService.searchRepos(of: "dongmin")
            .subscribe(onNext: { _ in })
            .dispose()
        
        // then
        let params = providerMock.networkMaterial
        
        XCTAssertEqual(correctURL, params?.url.absoluteString, "URL was diffferent")
        XCTAssertEqual(correctMethod, params?.method, "Method was different")
        XCTAssertEqual(correctHeader, params?.header, "Header was different")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
