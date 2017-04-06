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
  
  @IBOutlet weak var placeImageView: UIImageView!
  var userLocation: CLLocationCoordinate2D?
  var markerCoordinate: CLLocationCoordinate2D?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeImageView.layer.cornerRadius = 10
    placeImageView.clipsToBounds = true
    
    navigationController?.navigationBar.tintColor = UIColor.black
  }

}
