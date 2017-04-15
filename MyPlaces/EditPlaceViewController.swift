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
