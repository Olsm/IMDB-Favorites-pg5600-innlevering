//
//  IMDB_FavoritesUITests.swift
//  IMDB FavoritesUITests
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import XCTest

class IMDB_FavoritesUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecommendedToggle() {
        //XCTAssertFalse(app.)
        app.buttons["Recommended"].tap()
        //XCTAssertTrue(app.recommendedMode)
        app.buttons["All"].tap()
        //XCTAssertFalse(app.recommendedMode)
        
//vc.segmentChanged(vc.recommendedSwitch)
    }
    
}
