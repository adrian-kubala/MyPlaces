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
  
  private let view: UIView
  
  init(view: UIView) {
    self.view = view
  }
  
  func drawViewByBezierPath(sliceSide: SliceSide, with color: UIColor) {
    let bezierPath = UIBezierPath()
    bezierPath.move(to: view.bounds.origin)
    
    var rightTop = CGPoint(x: view.bounds.maxX, y: view.bounds.origin.y)
    let rightBottom = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
    var leftBottom = CGPoint(x: view.bounds.origin.x, y: view.bounds.maxY)
    
    switch sliceSide {
    case .top(let offset):
      rightTop.y += offset
    case .bottom(let offset):
      leftBottom.y -= offset
    }
    
    bezierPath.addLine(to: rightTop)
    bezierPath.addLine(to: rightBottom)
    bezierPath.addLine(to: leftBottom)
    bezierPath.close()
    
    color.setFill()
    bezierPath.fill()
    
    color.setStroke()
    bezierPath.stroke()
  }
  
}
