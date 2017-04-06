//
//  ChatViewController.swift
//  Places
//
//  Created by Adrian on 25.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import CoreLocation

class ChatViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
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
  
    let cameraIsAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    let photoLibraryIsAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    if photoSourceControl.selectedSegmentIndex == 0 && photoLibraryIsAvailable {
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    } else if cameraIsAvailable {
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let cropRect = info["UIImagePickerControllerCropRect"] as? CGRect
    var originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
    
    if let croppedRect = cropRect {
      originalImage = originalImage?.cropToRect(croppedRect)
    } else {
      originalImage = originalImage?.cropToBounds(width: placeImageView.bounds.size.width, height: placeImageView.bounds.size.height)
    }
    
    placeImageView.image = originalImage
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
