//
//  Place.swift
//  Places
//
//  Created by Adrian on 15.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import GooglePlaces

class Place {
  var name: String
  var address: String?
  var distance: Int = 0
  var coordinate: CLLocationCoordinate2D
  var photo: UIImage
  
  var addressDidObtain: (() -> ())?
  
  init(name: String, address: String?, coordinate: CLLocationCoordinate2D, photo: UIImage, userLocation: CLLocationCoordinate2D) {
    self.name = name
    self.address = address
    self.coordinate = coordinate
    self.photo = photo
    distance = getDistance(from: coordinate, to: userLocation)
  }
  
  func getDistance(from place: CLLocationCoordinate2D, to otherPlace: CLLocationCoordinate2D) -> Int {
    let firstLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
    let secondLocation = CLLocation(latitude: otherPlace.latitude, longitude: otherPlace.longitude)
    
    let distanceInMeters = secondLocation.distance(from: firstLocation)
    distance = Int(distanceInMeters)
    return distance
  }
}
