//
//  GeoPoint.swift
//  Maptastic
//
//  Created by Vorn Mom on 7/2/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import Foundation

public class GeoPoint {
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }

  func equals(otherPoint: GeoPoint) -> Bool {
    return otherPoint.latitude == latitude &&
      otherPoint.longitude == longitude
  }
  
}