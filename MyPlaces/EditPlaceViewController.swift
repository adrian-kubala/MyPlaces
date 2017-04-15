//
//  EditPlaceViewController.swift
//  MyPlaces
//
//  Created by Adrian Kubała on 15.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import UIKit

class EditPlaceViewController: UIViewController {
  
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var placeNameTextField: UITextField!
  
  weak var delegate: EditPlaceViewControllerDelegate?
  
  var place: Place!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeNameTextField.text = place.name
    placeImageView.image = place.photo
  }
  
}
