//
//  SearchResultTests.swift
//  Technical ChallengeTests
//
//  Created by Nataniel Martin on 16/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import Technical_Challenge

class SearchResultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "repositories", withExtension: "json") else {
            fatalError("Missing repositories.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let decodedResult = try! decoder.decode(SearchResult<Repository>.self,from: jsonData)
        
        XCTAssertFalse(decodedResult.isResultIncomplete)
        XCTAssertEqual(decodedResult.items.count, 30)
        XCTAssertEqual(decodedResult.totalCount, 1091671)
    }
    
 
}
