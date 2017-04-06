//
//  ChatViewController.swift
//  Places
//
//  Created by Adrian on 25.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import CoreLocation

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var photoSourceControl: UISegmentedControl!
  @IBOutlet weak var coordinateControl: UISegmentedControl!
  @IBOutlet weak var addPhotoButton: UIButton!
  
  var userLocation: CLLocationCoordinate2D?
  var markerCoordinate: CLLocationCoordinate2D?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupSubviews()
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.tintColor = UIColor.black
  }
  
  private func setupSubviews() {
    let cornerRadius: CGFloat = 5
    
    placeImageView.layer.cornerRadius = cornerRadius
    photoSourceControl.layer.cornerRadius = cornerRadius
    coordinateControl.layer.cornerRadius = cornerRadius
    addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
  }
  
  @IBAction func addPicture(_ sender: Any) {
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) && photoSourceControl.selectedSegmentIndex == 0 {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)
    }
  }
  
}
