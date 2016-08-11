//
//  MathUtil.swift
//  Pods
//
//  Created by Vorn Mom on 8/5/16.
//
//

import Foundation

public class MathUtil {

  class func degreesToRadians(val: Double) -> Double { return val * M_PI / 180 }
  class func radiansToDegrees(val: Double) -> Double { return val * 180 / M_PI }
  
  class func pointsBetweenPath(path: [Point], distanceStep: Double) -> [Point] {
    var pointsList: [Point] = []
    
    var startDistance: Double = 0
    for (var i = 0; i < path.count - 1; i++) {
      var distanceBetweenPoints = distanceBetweenTwoPoints(path[i], point1: path[i+1])
      
      var currentDistance: Double
      for currentDistance = startDistance; currentDistance < distanceBetweenPoints; currentDistance += distanceStep {
        var point: Point = pointBetweenTwoPoints(path[i], point1: path[i + 1], distance: currentDistance)
        pointsList.append(point)
      }
      startDistance = currentDistance - distanceBetweenPoints
    }
    
    pointsList.append(path[path.count - 1])
    
    return pointsList
  }
  
  class func distanceBetweenTwoPoints(point0: Point, point1: Point) -> Double {
    return sqrt((point1.x - point0.x) * (point1.x - point0.x) + (point1.y - point0.y) * (point1.y - point0.y))
  }
  
  class func pointBetweenTwoPoints(point0: Point, point1: Point, distance: Double) -> Point{
    var v0: Double = point1.x  - point0.x
    var v1: Double = point1.y - point0.y
    var vlen: Double = sqrt(v0 * v0 + v1 * v1)
    var nv0: Double = v0 / vlen
    var nv1: Double = v1 / vlen
    var vl0: Double = point0.x + distance * nv0
    var vl1: Double = point0.y + distance * nv1
    
    return Point(x: vl0, y: vl1)
  }
}