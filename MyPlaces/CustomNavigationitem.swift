//
//  CustomNavigationitem.swift
//  Places
//
//  Created by Adrian on 29.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

class CustomNavigationitem: UINavigationItem {
  func setupIcon(_ name: String) {
    var image = UIImage(named: name)
    image = image?.withRenderingMode(.alwaysOriginal)
    
    let locationImage = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    let flexibleSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    leftBarButtonItems = [flexibleSpace, locationImage]
  }
}
