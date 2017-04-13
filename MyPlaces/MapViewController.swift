//
//  ViewController.swift
//  Places
//
//  Created by Adrian on 15.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps

class MapViewController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: CLLocationManager?
    var placePicker: GMSPlacePicker?
    
    
    
    @IBAction func pickPlace(sender: AnyObject) {
        let place = Place()
        
        let center = CLLocationCoordinate2DMake(place.latitude, place.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            guard error == nil else {
                print("Pick Place error: \(error?.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress)")
            print("Place attributions \(place.attributions)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//        
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//        
//        let subView = UIView(frame: CGRectMake(0, 65.0, 350.0, 45.0))
//        
//        subView.addSubview((searchController?.searchBar)!)
//        self.view.addSubview(subView)
//        searchController?.searchBar.sizeToFit()
//        searchController?.hidesNavigationBarDuringPresentation = false
//        
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        self.definesPresentationContext = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        let place = Place()
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .AuthorizedWhenInUse else {
            return
        }
        
        locationManager?.startUpdatingLocation()
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let place = Place()
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager?.stopUpdatingLocation()
    }
}

//extension PlaceController: GMSAutocompleteResultsViewControllerDelegate {
//    func resultsController(viewController: GMSAutocompleteResultsViewController, didAutocompleteWithPlace place: GMSPlace) {
//        
//    }
//    
//    func resultsController(resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: NSError) {
//        
//    }
//    
//    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
//        
//    }
//    
//    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
//        
//    }
//}
