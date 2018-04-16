//
//  Technical_ChallengeUITests.swift
//  Technical ChallengeUITests
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest

class Technical_ChallengeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchEnvironment["-ShouldMockResponse"] = "YES"
        
        continueAfterFailure = false
        app.launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
}
