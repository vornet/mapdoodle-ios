//
//  AnimatedPathDoodle.swift
//  Pods
//
//  Created by Vorn Mom on 7/17/16.
//
//

import Foundation
import MapKit

public class AnimatedPathDoodle : Doodle {
  
  public var id: String!
  public var points: [GeoPoint]
  private var style: AnimatedPathDoodleStyle
  // var polyline: Polyline
  private var tracerDoodle: PathDoodle!
  private var animationContext: AnimationContext!
  private var shouldRedraw: Bool = true
  private var isBeingRemoved: Bool = false
  private var refreshRate: Int
  
  private var polyline: MKPolyline!
    private var mapView: MKMapView!
  
  init(style: AnimatedPathDoodleStyle, points: [GeoPoint], refreshRate: Int) {
    self.style = style
    self.points = points
    self.refreshRate = refreshRate
  }
  
  public func remove() {
    if (isBeingRemoved) {
      return;
    }
    
    isBeingRemoved = true
    if polyline != nil && mapView != nil {
      mapView.removeOverlay(polyline);
      polyline = nil
    }
  }
  
  public var bounds: [GeoPoint] {
    get {
      return LocationUtil.getBounds(points)
    }
  }
  
  func calculatePathPoints() {
    var path: [Point] = []
    for i in 0..<points.count {
      let geoPoint: GeoPoint = points[i]
      let x: Double = (geoPoint.longitude + 180)
      let y: Double = (geoPoint.latitude + 90)
      
      path.append(Point(x: x, y: y))
    }
    
    let speedInLatLong: Double = style.speed / 111 / 3600 / 1000 * Double(refreshRate)
    
    var pointsBetweenPaths: [Point] = MathUtil.pointsBetweenPath(path, distanceStep: speedInLatLong)
    
    animationContext.points = []
    for i in 0..<pointsBetweenPaths.count {
      animationContext.points.append(GeoPoint(latitude: pointsBetweenPaths[i].y - 90, longitude: pointsBetweenPaths[i].x - 180))
    }
    
  }
  
  public func draw(context: DoodleContext) {
    if mapView == nil {
      mapView = context.mapView
    }
    
    if isBeingRemoved {
      return;
    }
    
    if polyline == nil || shouldRedraw {
      if polyline != nil {
        context.mapView.removeOverlay(polyline)
        tracerDoodle.remove()
      }
      
      if tracerDoodle != nil {
        tracerDoodle.remove();
      }
      
      if style.tracerThickness > 0 {
        let pathStyle = PathDoodleStyle()
        pathStyle.thickness = style.tracerThickness
        pathStyle.color = style.tracerColor
        pathStyle.zIndex = style.zIndex
        
        tracerDoodle = PathDoodle(style: pathStyle, points: self.points)
      }
      
      animationContext = AnimationContext()
      calculatePathPoints()
      shouldRedraw = false
    }
    
    if tracerDoodle != nil {
      tracerDoodle.draw(context)
    }
    
    
    let currentPoint: GeoPoint = animationContext.points[animationContext.currentPointIndex]
    
    animationContext.coordinates.append(CLLocationCoordinate2D(latitude: currentPoint.latitude, longitude: currentPoint.longitude))
    
    if self.polyline != nil {
      context.mapView.removeOverlay(self.polyline)
    }
    
    self.polyline = MKPolyline(coordinates: &animationContext.coordinates, count: animationContext.coordinates.count)
    self.polyline.title = MapDoodler.ANIMATE_OVERLAY_ID
    context.mapView.addOverlay(self.polyline)
    
    animationContext.currentPointIndex += 1
    
    if animationContext.currentPointIndex >= animationContext.points.count {
      animationContext.coordinates.removeAll()
      animationContext.currentPointIndex = 0
    }
  }
  
  public func setupPolylineRenderer(polyline: MKPolyline) -> MKPolylineRenderer? {
    var polylineRenderer: MKPolylineRenderer? = nil
    
    if self.polyline === polyline {
      polylineRenderer = MKPolylineRenderer(overlay: polyline)
      polylineRenderer!.strokeColor = style.color
      polylineRenderer!.lineWidth = CGFloat(style.thickness / 2.5)
    } else {
      polylineRenderer = self.tracerDoodle.setupPolylineRenderer(polyline)
    }
    
    return polylineRenderer
  }
  
}

private class AnimationContext {
  var points: [GeoPoint] = []
  var currentPointIndex: Int = 0
  var coordinates: [CLLocationCoordinate2D] = []
}