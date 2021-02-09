//
//  ViewControllerTests.swift
//  RxSwift_3stepTests
//
//  Created by USER on 2021/02/08.
//

import XCTest
@testable import RxSwift
@testable import RxSwift_3step
import RxBlocking

class ViewControllerTests: XCTestCase {
    private var searchVC: ViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let naviVC = storyboard.instantiateViewController(withIdentifier: "CustomNavigation") as? UINavigationController else { return }
        guard let searchVC = naviVC.viewControllers.first as? ViewController else { return }
        self.searchVC = searchVC
        self.searchVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_insertSearchKeyword() {
        // given
        let keyword = "Hi"
        
        // when
        self.searchVC.navigationItem.searchController?.searchBar.searchTextField.insertText(keyword)
            
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.searchVC.searchViewModel.userName.onCompleted()
        }
        // then
        let searchName = try? self.searchVC.searchViewModel.userName.toBlocking(timeout: 3.0).last()
        
        XCTAssertEqual(searchName, keyword)
    }
    
    func test_getRepository() {
        // given
        var gitRepositories: [GitRepository] = []
        
        for _ in 0...10 {
            let repository = GitRepository(full_name: "Some")
            gitRepositories.append(repository)
            
            // when
            self.searchVC.searchViewModel.gitRepository.onNext(gitRepositories)
            let repositoriesCount = gitRepositories.count
            
            // then
            XCTAssertEqual(repositoriesCount, self.searchVC.resultTableView.numberOfRows(inSection: 0), "Binding was failed")
        }
    }
    
    func test_CellReuseIdentifier() {
        // given
        let tempRepository = GitRepository(full_name: "Rx_Swift")
        self.searchVC.searchViewModel.gitRepository.onNext([tempRepository])
        let cell = self.searchVC.resultTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        let correctIdentifier = "customcell"
        
        XCTAssertEqual(correctIdentifier, cell?.reuseIdentifier, "ReuseIdentifier was wrong")
    }
    
    func test_ActivityIndicator_animate_loading() {
        // give
        let animating = true
    
        // when
        self.searchVC.searchViewModel.searching.onNext(animating)
        
        // then
        XCTAssertEqual(self.searchVC.activityIndicator.isAnimating, animating, "Test was Failed")
    }
    
    func test_ActivityIndicator_animate_notLoading() {
        // give
        let animated = false
        
        // when
        self.searchVC.searchViewModel.searching.onNext(animated)

        // then
        XCTAssertEqual(self.searchVC.activityIndicator.isAnimating, animated, "Test was Failed")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
