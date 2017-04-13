//
//  CreatorViewControllerDelegate.swift
//  MyPlaces
//
//  Created by Adrian Kubała on 07.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import Foundation

protocol CreatorViewControllerDelegate: class {
  
  func didCreatePlace(_ place: Place)
  
}
