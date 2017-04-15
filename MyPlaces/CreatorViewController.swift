//
//  ChatViewController.swift
//  Places
//
//  Created by Adrian on 25.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit
import CoreLocation

class CreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var photoSourceControl: UISegmentedControl!
  @IBOutlet weak var coordinateControl: UISegmentedControl!
  @IBOutlet weak var addPhotoButton: UIButton!
  @IBOutlet weak var addPlaceButton: TopSlicedButton!
  @IBOutlet weak var placeNameTextField: UITextField!
  
  var userLocation: CLLocationCoordinate2D?
  var markerCoordinate: CLLocationCoordinate2D?
  
  weak var delegate: CreatorViewControllerDelegate?
  
  var didChoosePlacePhoto = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubviews()
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
    
    if photoSourceControl.selectedSegmentIndex == 0 && cameraIsAvailable {
      imagePicker.sourceType = .camera
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)
    } else if photoLibraryIsAvailable {
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
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
    didChoosePlacePhoto = true
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  @IBAction func addPlace() {
    guard let isEmpty = placeNameTextField.text?.isEmpty, isEmpty == false else {
      let alertController = UIAlertController(title: "Did not enter title", message: "You need to enter a title to add a new place.", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default) { action in
        self.placeNameTextField.becomeFirstResponder()
      }
      alertController.addAction(alertAction)
      alertController.view.tintColor = UIColor.black
      present(alertController, animated: true, completion: nil)
      
      return
    }
    
    let newPlaceCoordinate = coordinateControl.selectedSegmentIndex == 0 ? markerCoordinate : userLocation

    let newPlace = Place(name: placeNameTextField.text!, address: nil, coordinate: newPlaceCoordinate!, photo: placeImageView.image!, userLocation: userLocation!)
    if !didChoosePlacePhoto {
      newPlace.photo = #imageLiteral(resourceName: "av-location")
    }
    newPlace.coordinate.formattedAddress { (address) in
      newPlace.address = address
      newPlace.addressDidObtain?()
    }
    
    delegate?.didCreatePlace(newPlace)
    _ = navigationController?.popViewController(animated: true)
  }
  
}
