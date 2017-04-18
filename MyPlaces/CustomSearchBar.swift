//
//  CustomSearchBar.swift
//  Places
//
//  Created by Adrian on 29.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import CoreLocation

class CustomSearchBar: UISearchBar {
  var textField: UITextField {
    return value(forKey: "searchField") as! UITextField
  }
  
  func setupSearchBar() {
    setupImages()
    setupTextField()
  }
  
  fileprivate func setupImages() {
    var image = UIImage(named: "loc-clear")
    setImage(image, for: .clear, state: UIControlState())
    
    image = UIImage(named: "loc-current")
    setImage(image, for: .search, state: UIControlState())
  }
  
  fileprivate func setupTextField() {
    setupTextFieldBackgroundColor()
    setupClearButton()
    autocapitalizationType = .none
    text = " "
  }
  
  fileprivate func setupTextFieldBackgroundColor() {
    textField.backgroundColor = barTintColor
  }
  
  fileprivate func setupClearButton() {
    textField.clearButtonMode = .whileEditing
  }
  
  func changeSearchIcon() {
    if isActive() {
      setupSearchIcon()
    } else {
      setupCurrentLocationIcon()
    }
  }
  
  func setupSearchIcon() {
    let image = UIImage(named: "loc-search")!
    setImage(image, for: .search, state: UIControlState())
  }
  
  func setupCurrentLocationIcon() {
    let image = UIImage(named: "loc-current")!
    setImage(image, for: .search, state: UIControlState())
  }
  
  func updateSearchText(with placemark: CLPlacemark) {
    if let street = placemark.thoroughfare, let city = placemark.locality, let country = placemark.country {
      let separator = ", "
      let formattedAddress = street + separator + city + separator + country
      text = formattedAddress
    }
  }
  
  func updateSearchText(_ text: String) {
    self.text = text
  }
  
  func isActive() -> Bool {
    return isFirstResponder ? true : false
  }
}
