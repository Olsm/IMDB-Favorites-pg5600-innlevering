//
//  IMDB_FavoritesTests.swift
//  IMDB FavoritesTests
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import XCTest
@testable import IMDB_Favorites

var vc: FavoritesViewController!

class IMDB_FavoritesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        vc.loadView()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRecommendedMode() {
        XCTAssertFalse(vc.recommendedMode)
        vc.recommendedMode(enabled: true)
        XCTAssertTrue(vc.recommendedMode)
    }
    
    /*
    func testIsRecommeded() {
        let movie = Movie()
        movie.rating = 7.1
        movie.seen = date3YearsAgo()
        
        XCTAssertTrue(movie.isRecommended())
    }
    
    func testIsNotRecommendedByDate() {
        let movie = Movie()
        movie.rating = 7.1
        movie.seen = Date()
        
        XCTAssertFalse(movie.isRecommended())
    }
    
    func testisNotRecommendedByRating() {
        let movie = Movie()
        movie.rating = 7.0
        movie.seen = Date()
        
        XCTAssertFalse(movie.isRecommended())
    }
    
    func date3YearsAgo() -> Date {
        return Calendar.current.date(byAdding: .year, value: -3, to: Date())!
    }
     */
    
}
