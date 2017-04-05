//
//  TopSlicedButton.swift
//  NearbyPlaces
//
//  Created by Adrian Kubała on 06.04.2017.
//  Copyright © 2017 Adrian Kubała. All rights reserved.
//

import UIKit

class TopSlicedButton: UIButton, Sliced {

  override func draw(_ rect: CGRect) {
    drawSlicedView(rightTopCornerOffset: 5)
    setupImageView()
  }
  
  func setupImageView() {
    let imgView = UIImageView()
    imgView.image = UIImage(named: "tick")
    imgView.changeTintColor(UIColor.white)
    setImage(imgView.image, for: UIControlState())
  }
  
}

protocol Sliced {
  
  func drawSlicedView(leftBottomCornerOffset: CGFloat, rightTopCornerOffset: CGFloat, with color: UIColor)
  
}

extension Sliced where Self: UIView {
  
  func drawSlicedView(leftBottomCornerOffset: CGFloat = 0, rightTopCornerOffset: CGFloat = 0, with color: UIColor = .black) {
    let customView = CustomView(view: self)
    customView.drawViewByBezierPath(leftBottomCornerOffset: leftBottomCornerOffset, rightTopCornerOffset: rightTopCornerOffset, with: color)
  }
  
}
