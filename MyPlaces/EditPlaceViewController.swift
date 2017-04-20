//
//  EditPlaceViewController.swift
//  MyPlaces
//
//  Created by Adrian Kubała on 15.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import UIKit

class EditPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var placeNameTextField: UITextField!
  @IBOutlet weak var photoSourceControl: UISegmentedControl!
  @IBOutlet weak var addPhotoButton: UIButton!
  @IBOutlet weak var applyButton: TopSlicedButton!
  
  weak var delegate: EditPlaceViewControllerDelegate?
  
  var place: Place!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    placeNameTextField.text = place.name
    placeImageView.image = place.photo
    setupSubviews()
  }
  
  private func setupSubviews() {
    let cornerRadius: CGFloat = 5
    
    placeImageView.layer.cornerRadius = cornerRadius
    photoSourceControl.layer.cornerRadius = cornerRadius
    addPhotoButton.layer.cornerRadius = addPhotoButton.bounds.size.width / 2
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    changeContentModeIfNeeded()
  }
  
  private func changeContentModeIfNeeded() {
    if let placeImage = placeImageView.image, placeImage.size.width > placeImageView.bounds.size.width {
      placeImageView.contentMode = .scaleAspectFill
    } else {
      placeImageView.contentMode = .center
    }
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
    dismiss(animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @IBAction func applyChanges() {
    guard let isEmpty = placeNameTextField.text?.isEmpty, isEmpty == false else {
      let alertController = UIAlertController(title: "Did not provide a new title", message: "You need to enter a title to add a new place.", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default) { action in
        self.placeNameTextField.becomeFirstResponder()
      }
      alertController.addAction(alertAction)
      alertController.view.tintColor = UIColor.black
      present(alertController, animated: true, completion: nil)
      
      return
    }
    
    place.name = placeNameTextField.text!
    place.photo = placeImageView.image!
    
    delegate?.didEditPlace()
    _ = navigationController?.popViewController(animated: true)
  }
  
}
