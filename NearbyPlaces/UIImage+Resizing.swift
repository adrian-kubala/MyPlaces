//
//  UIImage+Resizing.swift
//  Places
//
//  Created by Adrian on 29.09.2016.
//  Copyright © 2016 Adrian Kubała. All rights reserved.
//

import UIKit

extension UIImage {
  func cropToBounds(width: CGFloat, height: CGFloat) -> UIImage {
    let contextImage = UIImage(cgImage: cgImage!)
    let contextSize = contextImage.size
    
    var posX = CGFloat(0.0)
    var posY = CGFloat(0.0)
    var newWidth = width
    var newHeight = height
    
    if contextSize.width > contextSize.height {
      posX = ((contextSize.width - contextSize.height) / 2)
      posY = 0
      newWidth = contextSize.height
      newHeight = contextSize.height
    } else {
      posX = 0
      posY = ((contextSize.height - contextSize.width) / 2)
      newWidth = contextSize.width
      newHeight = contextSize.width
    }
    
    let rect = CGRect(x: posX, y: posY, width: newWidth, height: newHeight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let newImage = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    
    return newImage
  }
  
  func scaleImage(width: CGFloat) -> UIImage {
    let newWidth = width
    let scale = newWidth / size.width
    let newHeight = size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
}
