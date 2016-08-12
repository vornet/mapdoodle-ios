//
//  MapDoodle.swift
//  Maptastic
//
//  Created by Vorn Mom on 7/2/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import Foundation
import MapKit

public class MapDoodler: NSObject, MKMapViewDelegate {
  var path: GeoPath = GeoPath()
  var mapView: MKMapView
  var refreshRate: Int
  var doodles: [Doodle] = []
  var isPausing: Bool = false

  private var drawTimer: NSTimer!
  
  static let TRACE_OVERLAY_ID = "trace"
  static let ANIMATE_OVERLAY_ID = "animate"
  
  var lastCamera: MKMapCamera?
  
  public init(mapView: MKMapView, refreshRate: Int) {
    self.mapView = mapView
    self.refreshRate = refreshRate
    
    super.init()
    self.mapView.delegate = self
    
    self.drawTimer = NSTimer.scheduledTimerWithTimeInterval(Double(self.refreshRate) / 1000.0, target: self,
                                                                 selector: #selector(MapDoodler.draw), userInfo: nil, repeats: true)
  }
  
  public func addPathDoodle(style: PathDoodleStyle, points: [GeoPoint]) -> Doodle {
    let doodle = PathDoodle(style: style, points: points)
    self.doodles.append(doodle)
    return doodle
  }
  
  public func addAnimatedPathDoodle(style: AnimatedPathDoodleStyle, points: [GeoPoint]) -> Doodle {
    let doodle = AnimatedPathDoodle(style: style, points: points, refreshRate: refreshRate)
    self.doodles.append(doodle)
    return doodle
  }
  
  public func zoomFitAllDoodles(padding: Int, shouldAnimate: Bool) {
    var allPaths: [GeoPoint] = []
    
    for var doodle in doodles {
      allPaths.appendContentsOf(doodle.points)
    }
    
    // Hacky: Using setRegion(animated: false) to capture the final position for lastCamera.
    let oldCamera = mapView.camera.copy() as! MKMapCamera
    self.mapView.setRegion(regionForGeoPath(allPaths), animated: false)
    lastCamera = self.mapView.camera.copy() as! MKMapCamera
    self.mapView.setCamera(oldCamera, animated: false)
    
    self.mapView.setRegion(regionForGeoPath(allPaths), animated: shouldAnimate)
  }
  
  public func zoomToFitDoodle(doodle: Doodle, padding: Int, shouldAnimate: Bool, shouldChangeBearing: Bool) {
    var doodleIndex: Int = doodles.indexOf({ $0 === doodle })!
    if doodleIndex >= 0 {
      var bearing: Float = 0
      if shouldChangeBearing {
        var points: [GeoPoint] = doodle.points
        bearing = Float(LocationUtil.getBearing(points[points.count-1], end: points[0]))
        mapView.camera.pitch = CGFloat(bearing)
      }
      
      var r = regionForGeoPath(doodle.points)
      self.mapView.setRegion(r, animated: false)
      
      let newCamera = mapView.camera.copy() as! MKMapCamera
      newCamera.heading = CLLocationDirection(bearing)
      
      if lastCamera != nil {
        mapView.setCamera(lastCamera!, animated: false)
      }
      
      // Hacky: Using setCamera(animated: false) to capture the final position for lastCamera.
      let oldCamera = mapView.camera.copy() as! MKMapCamera
      mapView.setCamera(newCamera, animated: false)
      lastCamera = self.mapView.camera.copy() as! MKMapCamera
      self.mapView.setCamera(oldCamera, animated: false)
      
      mapView.setCamera(newCamera, animated: shouldAnimate)
    }
  }
  
  public func addPath(path: GeoPath) {
    self.path = path
    
    var coordinates = self.path.geoPoints.map({ geoPoint -> CLLocationCoordinate2D in CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)})
    
    let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
    polyline.title = MapDoodler.TRACE_OVERLAY_ID
    mapView.addOverlay(polyline)
    
    // Set region to an area that encompasses the coodinates.
    mapView.setRegion(regionForGeoPath(self.doodles[0].points), animated: false)
  }
  
  public func animatePath(speed: Double) -> GeoPathAnimator {
    let pathAnimator = GeoPathAnimator(mapView: mapView, pathToAnimate: path, speed: speed)
    pathAnimator.start()
    return pathAnimator
  }
  
  func regionForGeoPath(points: [GeoPoint]) -> MKCoordinateRegion {
    var upper = CLLocationCoordinate2D(
      latitude: -90,
      longitude: -180)
    
    var lower = CLLocationCoordinate2D(
      latitude: 90,
      longitude: 180)
    
    for point: GeoPoint in points {
      lower.latitude = min(lower.latitude, point.latitude)
      lower.longitude = min(lower.longitude, point.longitude)
      upper.latitude = max(upper.latitude, point.latitude)
      upper.longitude = max(upper.longitude, point.longitude)
    }
    
    let multiplyer = 1.6
    
    var locationSpan = MKCoordinateSpan()
    locationSpan.latitudeDelta = (upper.latitude - lower.latitude) * multiplyer
    locationSpan.longitudeDelta = (upper.longitude - lower.longitude) * multiplyer
    
    var locationCenter = CLLocationCoordinate2D()
    locationCenter.latitude = (upper.latitude + lower.latitude) / 2
    locationCenter.longitude = (upper.longitude + lower.longitude) / 2
    
    return MKCoordinateRegion(center: locationCenter, span: locationSpan)
  }
  
  public func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    var overlayRenderer: MKPolylineRenderer? = nil
    
    if overlay is MKPolyline {
      
      for doodle in doodles {
        overlayRenderer = doodle.setupPolylineRenderer(overlay as! MKPolyline)
        if overlayRenderer != nil {
          break;
        }
      }
      
      return overlayRenderer!
    }
    
    return MKPolylineRenderer()
  }
  
  public func draw() {
    if !isPausing {
      var doodleContext = DoodleContext(mapView: self.mapView)
      for doodle in self.doodles {
        doodle.draw(doodleContext)
      }
    }
  }
}