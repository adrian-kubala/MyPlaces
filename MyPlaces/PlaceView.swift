//
//  PlaceView.swift
//  Places
//
//  Created by Adrian on 25.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

class PlaceView: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var address: UILabel!
  @IBOutlet weak var photo: UIImageView!
  
  func setupWithData(_ place: Place) {
    setupName(place.name)
    setupPhoto(place.photo)
    
    setupAddress(place.address, distance: place.distance)
    if place.address == nil {
      place.addressDidObtain = { [weak self] in
        self?.setupAddress(place.address, distance: place.distance)
      }
    }
  }
  
  private func setupName(_ name: String) {
    self.name.text = name
  }
  
  private func setupAddress(_ address: String?, distance: Int) {
    var distanceText = distance < 1000 ? "\(distance) m" : String(format: "%.2f", Double(distance) / 1000) + " km"
    if let address = address {
      distanceText += " | \(address)"
    }
    
    self.address.text = distanceText
  }
  
  private func setupPhoto(_ photo: UIImage) {
    let photoWidth = self.photo.frame.size.width
    self.photo.layer.cornerRadius = photoWidth / 2
    self.photo.clipsToBounds = true
    if photo.size.width > 40 {
      let scaledPhoto = photo.scaleImage(width: photoWidth)
      self.photo.image = scaledPhoto.cropToBounds(width: photoWidth, height: photoWidth)
    } else {
      self.photo.image = photo
    }
  }
  
}
