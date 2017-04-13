//
//  CustomMapView.swift
//  Places
//
//  Created by Adrian on 29.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import MapKit

class CustomMapView: MKMapView {
  let pinView = UIImageView(image: UIImage(named: "map-location"))
  
  override func draw(_ rect: CGRect) {
    setupAnnotation()
  }
  
  func setupMapRegion(_ location: CLLocation) {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    setupRegion(center)
  }
  
  func setupMapRegionWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
    setupRegion(coordinate)
  }
  
  fileprivate func setupRegion(_ center: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    let region = MKCoordinateRegion(center: center, span: span)
    
    setRegion(region, animated: true)
  }
  
  fileprivate func setupAnnotation() {
    addSubview(pinView)
    centerPin()
  }
  
  fileprivate func centerPin() {
    pinView.center = convert(center, from: superview)
  }
  
  func hideAnnotationIfNeeded() {
    pinView.isHidden = true
  }
  
  func showAnnotation() {
    pinView.isHidden = false
  }
}
