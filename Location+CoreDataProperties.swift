//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Shehab Saqib on 29/12/2015.
//  Copyright © 2015 Shehab Saqib. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var date: Date
    @NSManaged var locationDescription: String
    @NSManaged var category: String
    @NSManaged var placemark: CLPlacemark?
    @NSManaged var photoID: NSNumber?

}
