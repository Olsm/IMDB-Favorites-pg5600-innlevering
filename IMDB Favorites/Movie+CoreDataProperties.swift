//
//  Movie+CoreDataProperties.swift
//  IMDB Favorites
//
//  Created by Olav on 08/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }

    @NSManaged public var title: String
    @NSManaged public var year: Int16
    @NSManaged public var id: String
    @NSManaged public var rating: Double
    @NSManaged public var runtime: String
    @NSManaged public var genre: String
    @NSManaged public var country: String
    @NSManaged public var seen: Date?

}
