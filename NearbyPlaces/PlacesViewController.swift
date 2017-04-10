//
//  PlacesViewController.swift
//
//  Created by Adrian on 23.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit

class PlacesViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate, CreatorViewControllerDelegate {
  @IBOutlet weak var searchBar: CustomSearchBar!
  @IBOutlet weak var mapView: CustomMapView!
  @IBOutlet weak var placesView: UITableView!
  @IBOutlet weak var centerLocationButton: UIButton!
  @IBOutlet weak var emptyUserPlacesLabel: UILabel!
  
  @IBOutlet weak var placesViewTopConstraint: NSLayoutConstraint!
  
  var locationManager = CLLocationManager()
  var placesClient = GMSPlacesClient()
  var nearbyPlaces: [Place] = []
  var typedPlaces: [Place] = []
  var userPlaces: [Place] = []
  
  var userLocation: CLLocationCoordinate2D {
    guard let location = locationManager.location?.coordinate else {
      print("Retrieving location error")
      return CLLocationCoordinate2D()
    }
    return location
  }
  
  var currentAddress = String()
  
  fileprivate var requestTimer = Timer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationItem()
    setupMapView()
    setupLocationManager()
    setupPlacesClient()
    setupTableView()
    setupSearchBar()
    showNearbyPlaces()
  }
  
  func setupNavigationItem() {
    let navigationItem = self.navigationItem as! CustomNavigationitem
    navigationItem.setupIcon("map-location")
  }
  
  func setupMapView() {
    mapView.delegate = self
  }
  
  func setupPlacesClient() {
    placesClient = GMSPlacesClient.shared()
  }
  
  func setupLocationManager() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  // MARK: - CLLocationManagerDelegate
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.mapView.setupMapRegion(locations.last!)
    setupGeocoder(locations.last!)

    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .denied, .notDetermined, .restricted:
      print("Authorization error")
    default:
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print(error)
  }
  
  func setupGeocoder(_ location: CLLocation) {
    location.coordinate.formattedAddress { (address) in
      self.currentAddress = address ?? "Current address"
      self.searchBar.text = address
    }
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKPointAnnotation {
      let identifier = "placePin"
      var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      if pinView == nil {
        pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView?.image = UIImage(named: "map-location")
      } else {
        pinView?.annotation = annotation
      }
      return pinView
    }
    
    return nil
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let center = mapView.centerCoordinate
    let bounds = setupMapBounds(center, span: 0.0002)
    let userIsInsideBounds = bounds.contains(userLocation)
    
    guard userIsInsideBounds == false else {
      self.mapView.hideAnnotationIfNeeded()
      centerLocationButton.isHidden = true
      searchBar.setupCurrentLocationIcon()
      return
    }
    
    self.mapView.showAnnotation()
    self.mapView.setupMapRegionWithCoordinate(center)
    searchBar.setupSearchIcon()
    centerLocationButton.isHidden = false
    
    let annotationLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    setupGeocoder(annotationLocation)
  }
  
  func setupTableView() {
    placesView.delegate = self
    placesView.dataSource = self
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return searchBar.isActive() ? 2 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchBar.isActive() {
      return section == 0 ? typedPlaces.count : nearbyPlaces.count
    } else {
      if userPlaces.count == 0 {
        emptyUserPlacesLabel.isHidden = false
      } else {
        emptyUserPlacesLabel.isHidden = true
      }
      return userPlaces.count
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if searchBar.isActive() {
      return section == 0 ? "Results" : "Nearby places"
    } else {
      return "My places"
    }
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 35
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeView") as! PlaceView
    
    let data = chooseData(forIndexPath: indexPath)
    cell.setupWithData(data)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = chooseData(forIndexPath: indexPath)
    let address = data.address
    let coordinate = data.coordinate
    
    mapView.setupMapRegionWithCoordinate(coordinate)
    currentAddress = address!
    clearSearchBarText()
    resizeTable()
  }
  
  func clearSearchBarText() {
    searchBar.text?.removeAll()
    _ = searchBarShouldEndEditing(searchBar)
    _ = searchBar.updateSearchText(currentAddress)
  }
  
  @IBAction func centerMapView(_ sender: AnyObject) {
    guard let userLocation = locationManager.location else {
      return
    }
    
    mapView.setupMapRegion(userLocation)
    centerLocationButton.isHidden = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! CreatorViewController
    
    destinationVC.markerCoordinate = mapView.centerCoordinate
    destinationVC.userLocation = userLocation
    destinationVC.delegate = self
  }
  
  func setupSearchBar() {
    searchBar.setupSearchBar()
    searchBar.delegate = self
  }
  
  // MARK: - UISearchBarDelegate
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    requestTimer.invalidate()
    requestTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlacesViewController.makeRequestForPlaces), userInfo: nil, repeats: false)
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.changeSearchIcon()
    resizeTable()
    searchBar.text?.removeAll()
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    if self.searchBar.isActive() {
      searchBar.resignFirstResponder()
      return true
    }
    return false
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let isEmpty = searchBar.text?.isEmpty, isEmpty else {
      return
    }
    
    self.searchBar.changeSearchIcon()
    resizeTable()
    self.searchBar.updateSearchText(currentAddress)
    typedPlaces.removeAll()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func makeRequestForPlaces() {
    guard let searchText = searchBar.text, searchText.isEmpty == false else {
      _ = searchBarShouldEndEditing(searchBar)
      return
    }
    
    print(searchText)
    
    let bounds = setupMapBounds(userLocation, span: 0.01)
    placesClient.autocompleteQuery(searchText, bounds: bounds, filter: nil) { (predictions, error) -> Void in
      guard let predictions = predictions, error == nil else {
        print("Autocomplete error: \(error!.localizedDescription)")
        return
      }
      
      self.typedPlaces = []
      for prediction in predictions {
        guard let placeID = prediction.placeID else {
          continue
        }
        
        self.setupPlaceByID(placeID, location: self.userLocation)
      }
    }
  }
  
  func setupPlaceByID(_ placeID: String, location: CLLocationCoordinate2D) {
    placesClient.lookUpPlaceID(placeID) { (place, error) -> Void in
      if let predictedPlace = place {
        self.checkForPlacePhotos(predictedPlace, location: location)
      }
    }
  }
  
  func setupMapBounds(_ location: CLLocationCoordinate2D, span: Double) -> GMSCoordinateBounds {
    let northEast = CLLocationCoordinate2DMake(location.latitude + span, location.longitude + span)
    let southWest = CLLocationCoordinate2DMake(location.latitude - span, location.longitude - span)
    return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
  }
  
  func setupAutocompleteFilter() -> GMSAutocompleteFilter {
    let filter = GMSAutocompleteFilter()
    filter.country = "PL"
    return filter
  }
  
  func showNearbyPlaces() {
    placesClient.currentPlace { (placeLikelihoods, error) -> Void in
      guard let placeLikelihoods = placeLikelihoods, error == nil else {
        print("Nearby places error: \(error!.localizedDescription)")
        return
      }
      
      self.nearbyPlaces = []
      for likelihood in placeLikelihoods.likelihoods {
        let nearbyPlace = likelihood.place
        self.checkForPlacePhotos(nearbyPlace, location: self.userLocation)
      }
    }
  }
  
  func checkForPlacePhotos(_ place: GMSPlace, location: CLLocationCoordinate2D) {
    placesClient.lookUpPhotos(forPlaceID: place.placeID) { (photos, error) -> Void in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      self.setupPlaceWithPhoto(place, photo: photos?.results.first, location: location)
    }
  }
  
  func setupPlaceWithPhoto(_ place: GMSPlace, photo: GMSPlacePhotoMetadata?, location: CLLocationCoordinate2D) {
    guard let photo = photo else {
      let place = Place(name: place.name, address: place.formattedAddress, coordinate: place.coordinate, photo: UIImage(named: "av-location")!, userLocation: location)
      self.updatePlaces(with: place)
      
      return
    }
    
    placesClient.loadPlacePhoto(photo) { (placePhoto, error) -> Void in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      let place = Place(name: place.name, address: place.formattedAddress, coordinate: place.coordinate, photo: UIImage(), userLocation: location)
      
      let croppedImage = placePhoto?.cropToBounds(width: 40, height: 40)
      let scaledImage = croppedImage!.scaleImage(width: 40)
      place.photo = scaledImage
      
      self.updatePlaces(with: place)
    }
  }
  
  func updatePlaces(with place: Place) {
    if searchBar.isActive() {
      typedPlaces.append(place)
    } else {
      nearbyPlaces.append(place)
    }
    sortPlacesByDistance()
    placesView.reloadData()
  }
  
  func sortPlacesByDistance() {
    if searchBar.isActive() {
      typedPlaces.sort {
        $0.distance < $1.distance
      }
    } else {
      nearbyPlaces.sort {
        $0.distance < $1.distance
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    resizeTable()
  }
  
  func resizeTable() {
    if searchBar.isActive() {
      placesViewTopConstraint.constant -= placesView.frame.origin.y - searchBar.frame.maxY
      emptyUserPlacesLabel.isHidden = true
    } else {
      placesViewTopConstraint.constant = 0
      if userPlaces.isEmpty {
        emptyUserPlacesLabel.isHidden = false
      }
    }
    placesView.reloadData()
    animateTableResizing()
  }
  
  func animateTableResizing() {
    UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
      self.placesView.layoutIfNeeded()
    }, completion: nil)
  }
  
  func chooseData(forIndexPath indexPath: IndexPath) -> Place {
    if searchBar.isActive() {
      return indexPath.section == 0 ? typedPlaces[indexPath.row] : nearbyPlaces[indexPath.row]
    } else {
      return userPlaces[indexPath.row]
    }
  }
  
  func didCreatePlace(_ place: Place) {
    userPlaces.append(place)
    placesView.reloadData()
  }
}
