//
//  Technical_ChallengeTests.swift
//  Technical ChallengeTests
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import Technical_Challenge

class MainViewModelTests: XCTestCase {
    
    var viewModel = MainViewModel()
    
    override func setUp() {
        super.setUp()
        
        viewModel = MainViewModel(networkRessource: NetworkMockTest())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(viewModel.loadingStatus, .idle)
        XCTAssertEqual(viewModel.totalRepositories, 0)
    }
    
    func testVerifySearchText() {
        let nilStr = viewModel.verifySearchText(str: nil)
        XCTAssertNil(nilStr)
        
        let emptyStr = viewModel.verifySearchText(str: "")
        XCTAssertNil(emptyStr)
        
        let stringToTest = "Test String"
        let normalStr = viewModel.verifySearchText(str: stringToTest)
        XCTAssertEqual(normalStr?.count, stringToTest.count)
        
        let stringWithWhiteSpaceToTest = "     Test String     "
        let noWhiteSpaceStr = viewModel.verifySearchText(str: stringWithWhiteSpaceToTest)
        XCTAssertEqual(noWhiteSpaceStr?.count, stringToTest.count)
    }
    
    func testFetchFirstPage() {
        viewModel.fetchNextRepositories(with: "Test")
        XCTAssertEqual(viewModel.loadingStatus, .idle)
        XCTAssertEqual(viewModel.totalRepositories, 30)
    }
    
    func testRepositoryCellModel() {
        viewModel.fetchNextRepositories(with: "Test")
        let indexPath = IndexPath(row: 0, section: 0)
        let model = viewModel.repositoryCellModel(at: indexPath)
        
        XCTAssertEqual(model.title, "helloworld-infrastructure-production")
        XCTAssertEqual(model.description, "No description")
        XCTAssertEqual(model.fork, "9 forks")
        XCTAssertEqual(model.avatarURL?.absoluteString, "https://avatars2.githubusercontent.com/u/1123322?v=4")
    }
    
    func testForkNumberCellModel() {
        viewModel.fetchNextRepositories(with: "Test")
        let multipleForksIndexpath = IndexPath(row: 0, section: 0)
        let oneForkIndexpath = IndexPath(row: 1, section: 0)
        let zeroForkIndepath = IndexPath(row: 2, section: 0)
        
        let multipleForksModel = viewModel.repositoryCellModel(at: multipleForksIndexpath)
        let oneForkModel = viewModel.repositoryCellModel(at: oneForkIndexpath)
        let zeroForksModel = viewModel.repositoryCellModel(at: zeroForkIndepath)
        
        XCTAssertEqual(multipleForksModel.fork, "9 forks")
        XCTAssertEqual(oneForkModel.fork, "1 fork")
        XCTAssertEqual(zeroForksModel.fork, "No forks")
        
    }
    
    func testLoadingCellModel() {
        viewModel.fetchNextRepositories(with: "Test")
        let model = viewModel.loadingCellModel()
        XCTAssertEqual(model.showActivityIndicator, false)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
