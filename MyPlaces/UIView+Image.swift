//
//  UIView+Image.swift
//  MyPlaces
//
//  Created by Adrian Kubała on 04.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import UIKit

extension UIView {
  
  func imageFromContext() -> UIImage {
    UIGraphicsBeginImageContext(bounds.size)
    let context = UIGraphicsGetCurrentContext()
    layer.render(in: context!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
}
