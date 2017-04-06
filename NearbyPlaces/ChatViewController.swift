//
//  ChatViewController.swift
//  Places
//
//  Created by Adrian on 25.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import CoreLocation

class ChatViewController: UIViewController {
  
  @IBOutlet weak var addPhotoButton: UIButton!
  @IBOutlet weak var coordinateControl: UISegmentedControl!
  @IBOutlet weak var photoSourceControl: UISegmentedControl!
  @IBOutlet weak var placeImageView: UIImageView!
  var userLocation: CLLocationCoordinate2D?
  var markerCoordinate: CLLocationCoordinate2D?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeImageView.layer.cornerRadius = 5
    placeImageView.clipsToBounds = true
    
    photoSourceControl.layer.cornerRadius = 5
    coordinateControl.layer.cornerRadius = 5
    addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
    
    navigationController?.navigationBar.tintColor = UIColor.black
  }

}
