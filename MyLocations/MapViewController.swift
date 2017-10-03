//
//  MapViewController.swift
//  MyLocations
//
//  Created by Shehab Saqib on 15/01/2016.
//  Copyright © 2016 Shehab Saqib. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [Location]()
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { notification in
                if self.isViewLoaded {
                    self.updateLocations()
                }
            }
        }
    }
    
    
    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        let region = regionForAnnotations(locations)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        locations =  try! managedObjectContext.fetch(fetchRequest) as! [Location]
        
        mapView.addAnnotations(locations)
    }
    
    func regionForAnnotations(_ annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
        switch annotations.count {
            case 0:
                region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
            case 1:
                let annotation = annotations[annotations.count - 1]
                region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2, longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace, longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
            region = MKCoordinateRegionMake(center, span)
        }
        return mapView.regionThatFits(region)
    }
    
    func showLocationDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "EditLocation", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailsViewController
            controller.managedObjectContext = managedObjectContext
        }
    }
    }

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = false
            annotationView?.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            annotationView?.tintColor = UIColor(white: 0.0, alpha: 0.5)
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(MapViewController.showLocationDetails(_:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        let button = annotationView?.rightCalloutAccessoryView as! UIButton
        if let index = locations.index(of: annotation as! Location) {
            button.tag = index
        }
        
        return annotationView
    }
}


extension MapViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
