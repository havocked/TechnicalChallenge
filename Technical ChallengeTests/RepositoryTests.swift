//
//  RepositoryTests.swift
//  Technical ChallengeTests
//
//  Created by Nataniel Martin on 16/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import Technical_Challenge

class RepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitRepository() {
        
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "repository", withExtension: "json") else {
            fatalError("Missing repository.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let decodedResult = try! decoder.decode(Repository.self, from: jsonData)
        
        
        XCTAssertEqual(decodedResult.id, 60627891)
        XCTAssertEqual(decodedResult.name, "react-helloworld")
        XCTAssertEqual(decodedResult.fullName, "simonqian/react-helloworld")
        XCTAssertEqual(decodedResult.description, "react.js hello world")
        XCTAssertEqual(decodedResult.forks, 34)
        XCTAssertEqual(decodedResult.totalWatchers, 42)
        
        XCTAssertEqual(decodedResult.owner.id, 6582909)
        XCTAssertEqual(decodedResult.owner.avatarURL, "https://avatars3.githubusercontent.com/u/6582909?v=4")
        XCTAssertEqual(decodedResult.owner.login, "simonqian")
    }
    
}
