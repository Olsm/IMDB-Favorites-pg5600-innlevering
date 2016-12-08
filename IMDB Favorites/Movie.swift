//
//  Movie.swift
//  IMDB Favorites
//
//  Created by Olav on 05/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import Foundation

class Movie {
    var imdbId : String
    var title : String
    var year : Int
    var rating : Double
    var runtime : String
    
    init(imdbId: String, title: String, year: Int, rating: Double, runtime: String) {
        self.imdbId = imdbId
        self.title = title
        self.year = year
        self.rating = rating
        self.runtime = runtime
    }
}
