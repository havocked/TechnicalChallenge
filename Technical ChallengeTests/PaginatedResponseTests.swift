//
//  PaginatedResponseTests.swift
//  Technical ChallengeTests
//
//  Created by Nataniel Martin on 16/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import Technical_Challenge

class PaginatedResponseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let response = PaginatedResponse<String>(data: "Test", previousLink: nil, nextLink: "http://www.test.com?page=2")
        
        XCTAssertEqual(response.data, "Test")
        XCTAssertTrue(response.isFirst)
        XCTAssertFalse(response.isLast)
        XCTAssertNotNil(response.nextLinkURL)
        XCTAssertNil(response.previousLinkURL)
    }
    
    func testLastResponse() {
        let response = PaginatedResponse<String>(data: "Test", previousLink: "http://www.test.com?page=2", nextLink: nil)
        XCTAssertFalse(response.isFirst)
        XCTAssertTrue(response.isLast)
    }

}
