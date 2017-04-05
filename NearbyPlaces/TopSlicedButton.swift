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
    drawSlicedView(sliceSide: .top(offset: 5))
    setupImageView()
  }
  
  func setupImageView() {
    let imgView = UIImageView()
    imgView.image = UIImage(named: "tick")
    imgView.changeTintColor(UIColor.white)
    setImage(imgView.image, for: UIControlState())
  }
  
}
