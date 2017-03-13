//
//  UIImageView+TintColor.swift
//  Places
//
//  Created by Adrian on 28.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

extension UIImageView {
  func changeTintColor(_ color: UIColor) {
    image = image?.withRenderingMode(.alwaysTemplate)
    tintColor = color
  }
}
