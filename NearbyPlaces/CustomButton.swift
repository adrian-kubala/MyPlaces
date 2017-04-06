//
//  CustomButton.swift
//  Places
//
//  Created by Adrian on 28.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

class CustomButton: UIButton, Sliced {
  override func draw(_ rect: CGRect) {
    drawSlicedView(sliceSide:.bottom(offset: 5))
  }
  
}
