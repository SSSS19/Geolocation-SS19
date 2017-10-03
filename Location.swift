//
//  Location.swift
//  MyLocations
//
//  Created by Shehab Saqib on 29/12/2015.
//  Copyright © 2015 Shehab Saqib. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Location: NSManagedObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    var subtitle: String? {
        return category
    }
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoPath: String {
        assert(photoID != nil, "No photo ID set")
        let fileName = "Photo-\(photoID!.intValue).jpg"
        return (applicationDocumentsDirectory as NSString).appendingPathComponent(fileName)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    
    class func nextPhotoID() -> Int {
       let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID")
        userDefaults.set(currentID + 1, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
    
    func removePhotoFile() {
        if hasPhoto {
            let path = photoPath
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {
                    print("Error removing file: \(error)")
                }
            }
        }
    }

}
