//
//  Sliced.swift
//  MyPlaces
//
//  Created by Adrian Kubała on 06.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import UIKit

protocol Sliced {
  
  func drawSlicedView(sliceSide: SliceSide, with color: UIColor)
  
}

extension Sliced where Self: UIView {
  
  func drawSlicedView(sliceSide: SliceSide, with color: UIColor = .black) {
    let customView = CustomView(view: self)
    customView.drawViewByBezierPath(sliceSide: sliceSide, with: color)
  }
  
}
