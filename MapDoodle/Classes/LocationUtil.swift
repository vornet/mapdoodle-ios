//
//  LocationUtil.swift
//  Pods
//
//  Created by Vorn Mom on 8/2/16.
//
//

import Foundation

public class LocationUtil {
  static let LN2 = 0.6931471805599453
  static let WORLD_DP_HEIGHT = 256
  static let ZOOM_MAX = 21
  
  class func getBearing(start: GeoPoint, end: GeoPoint) -> Double {
    var startLat: Double = MathUtil.degreesToRadians(start.latitude)
    var startLong: Double = MathUtil.degreesToRadians(start.longitude)
    var endLat: Double = MathUtil.degreesToRadians(end.latitude)
    var endLong: Double = MathUtil.degreesToRadians(end.longitude)
    
    var dLong: Double = endLong - startLong
    
    var dPhi: Double = log(tan(endLat / 2.0 + M_PI / 4.0) / tan(startLat / 2.0 + M_PI / 4.0))
    
    if abs(dLong) > M_PI {
      if dLong > 0.0 {
        dLong = -(2.0 * M_PI - dLong)
      } else {
        dLong = 2.0 * M_PI + dLong
      }
    }
    
    return (MathUtil.radiansToDegrees(atan2(dLong, dPhi)) + 360.0) % 360.0;
  }
  
  class func getBounds(points: [GeoPoint]) -> [GeoPoint] {
    var bigLat: Double = 0
    var bigLong: Double = 0
    var smallLat: Double = 0
    var smallLong: Double = 0
    
    for point: GeoPoint in points {
      var normLat: Double = point.latitude + 180
      var normLong: Double = point.longitude + 180
      
      if normLat > bigLat {
        bigLat = normLat
      }
      if normLat < smallLat {
        smallLat = normLat
      }
      if normLat > bigLong {
        bigLong = normLong
      }
      if normLong < smallLong {
        smallLong = normLong
      }
    }
    
    return [
      GeoPoint(latitude: bigLat - 180, longitude: bigLong - 180),
      GeoPoint(latitude: smallLat - 180, longitude: smallLong - 180)
    ]
  }
  
}