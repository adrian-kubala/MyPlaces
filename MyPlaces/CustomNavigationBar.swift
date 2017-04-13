//
//  CustomNavigationBar.swift
//  Places
//
//  Created by Adrian on 29.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar, Sliced {
  
  override func draw(_ rect: CGRect) {
    drawSlicedView(sliceSide: .bottom(offset: 5.0), with: barTintColor!)
  }
  
}
