//
//  CustomView.swift
//  Places
//
//  Created by Adrian on 28.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView {
  fileprivate let view: UIView
  
  init(view: UIView) {
    self.view = view
  }
  
  func drawViewByBezierPath(leftBottomCornerOffset: CGFloat = 0, rightTopCornerOffset: CGFloat = 0, with color: UIColor) {
    let bezierPath = UIBezierPath()
    bezierPath.move(to: view.bounds.origin)
    bezierPath.addLine(to: CGPoint(x: view.bounds.maxX, y: view.bounds.origin.y + rightTopCornerOffset))
    bezierPath.addLine(to: CGPoint(x: view.bounds.maxX, y: view.bounds.maxY))
    bezierPath.addLine(to: CGPoint(x: view.bounds.origin.x, y: view.bounds.maxY - leftBottomCornerOffset))
    bezierPath.close()
    
    color.setFill()
    bezierPath.fill()
    
    color.setStroke()
    bezierPath.stroke()
  }
}
