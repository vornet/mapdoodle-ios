//
//  GeoPath.swift
//  Maptastic
//
//  Created by Vorn Mom on 7/2/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import Foundation

public class GeoPath {
  var geoPoints: [GeoPoint]
  
  public init() {
    geoPoints = []
  }
  
  public func addPoint(latitude: Double, longitude: Double) {
    addPoint(GeoPoint(latitude: latitude, longitude: longitude))
  }
  
  public func addPoint(point: GeoPoint) {
    geoPoints.append(point)
  }
  
  public func getPoint(index: Int) -> GeoPoint {
    return geoPoints[index]
  }
  
  public func count() -> Int {
    return geoPoints.count
  }
}