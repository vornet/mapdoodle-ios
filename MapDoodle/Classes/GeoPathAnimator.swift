//
//  GeoPathAnimator.swift
//  Maptastic
//
//  Created by Vorn Mom on 7/2/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import Foundation
import MapKit

public class GeoPathAnimator {
  let updateRate = 500.0
  
  private var pathToAnimate: GeoPath = GeoPath()
  private var animationContext: AnimationContext = AnimationContext()
  private var speed: Double = 0.0
  private var mapView: MKMapView
  
  init(mapView: MKMapView, pathToAnimate: GeoPath, speed: Double) {
    self.mapView = mapView
    self.pathToAnimate = pathToAnimate
    self.speed = speed
  }
  
  @objc func animate() {
    let startPoint = pathToAnimate.getPoint(animationContext.currentPointIndex)
    let endPoint = pathToAnimate.getPoint(animationContext.currentPointIndex + 1)
    
    var la: Double
    var lo: Double
    
    if(startPoint.equals(endPoint)) {
      animationContext.currentPointIndex += 1
      return
    }
    
    // Distance
    let distance: Double = calculateDistance(startPoint, point2: endPoint) / 1000.0
    let speedInMs: Double = speed / 3600 / 1000
    let divider: Double = distance * 1 / (speedInMs * updateRate)
    
    let step: Double = sqrt(pow(endPoint.latitude - startPoint.latitude, 2) + pow(endPoint.longitude - startPoint.longitude, 2)) / divider
    
    let x0 = startPoint.latitude
    let y0 = startPoint.longitude
    let x1 = endPoint.latitude
    let y1 = endPoint.longitude
    
    let m = (y1 - y0) / (x1 - x0)
    
    if(x1 < x0) {
      la = x0 - animationContext.xOffset / sqrt(1 + pow(m, 2))
    } else {
      la = x0 - animationContext.xOffset / sqrt(1 + pow(m, 2))
    }
    
    lo = m * (la - x0) + y0
    animationContext.xOffset += step
    
    if(abs(la - endPoint.latitude) < animationContext.endPointLatDiff &&
      abs(lo - endPoint.longitude) < animationContext.endPointLongDiff) {
      animationContext.endPointLatDiff = abs(la - endPoint.latitude)
      animationContext.endPointLongDiff = abs(lo - endPoint.longitude)
      animationContext.drawPointList.append(CLLocationCoordinate2D(latitude: la, longitude: lo))

      let polyline = MKPolyline(coordinates: &animationContext.drawPointList, count: animationContext.drawPointList.count)
      polyline.title = MapDoodle.ANIMATE_OVERLAY_ID
      if(animationContext.lastPolyline != nil) {
        mapView.removeOverlay(animationContext.lastPolyline)
      }
      mapView.addOverlay(polyline)
      animationContext.lastPolyline = polyline
      
      
    } else {
      animationContext.currentPointIndex += 1
      animationContext.xOffset = 0
      animationContext.endPointLatDiff = 360.0
      animationContext.endPointLongDiff = 360.0
      
      if(animationContext.currentPointIndex >= pathToAnimate.count() - 1) {
        animationContext.drawPointList.removeAll()
        animationContext.currentPointIndex = 0
        animationContext.xOffset = 0
      }
    }
  }
  
  func start() {
      var animationTimer = NSTimer.scheduledTimerWithTimeInterval(updateRate / 1000.0, target: self,
                                                                  selector: #selector(GeoPathAnimator.animate), userInfo: nil, repeats: true)
  }
  
  private func toRadians(val: Double) -> Double {
    return (M_PI / 180.0) * val
  }
  
  private func calculateDistance(point1: GeoPoint, point2: GeoPoint) -> Double {
    let R: Double = 6371000
    let o1: Double = toRadians(point1.latitude)
    let o2: Double = toRadians(point2.latitude)
    let dd: Double = toRadians(point2.latitude - point1.latitude)
    let d1: Double = toRadians(point2.longitude - point1.longitude)
    
    let a: Double = sin(dd / 2) * sin(dd / 2) +
      cos(o1) * cos(o2) * sin(d1 / 2) * sin(d1 / 2)
    let c: Double = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c
  }
}

private class AnimationContext {
  var currentPointIndex: Int = 0
  var xOffset: Double = 0.0
  var drawPointList: [CLLocationCoordinate2D] = []
  var lastPolyline: MKPolyline!
  var endPointLatDiff: Double = 360.0
  var endPointLongDiff: Double = 360.0
  
  init() {
    
  }
  
}