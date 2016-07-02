//
//  MapDoodle.swift
//  Maptastic
//
//  Created by Vorn Mom on 7/2/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import Foundation
import MapKit

public class MapDoodle: NSObject, MKMapViewDelegate {
  var path: GeoPath = GeoPath()
  var mapView: MKMapView
  static let TRACE_OVERLAY_ID = "trace"
  static let ANIMATE_OVERLAY_ID = "animate"
  
  public init(mapView: MKMapView) {
    self.mapView = mapView
    super.init()
    self.mapView.delegate = self
  }
  
  public func addPath(path: GeoPath) {
    self.path = path
    
    var coordinates = self.path.geoPoints.map({ geoPoint -> CLLocationCoordinate2D in CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)})
    
    let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
    polyline.title = MapDoodle.TRACE_OVERLAY_ID
    mapView.addOverlay(polyline)
    
    // Set region to an area that encompasses the coodinates.
    mapView.setRegion(regionForGeoPath(self.path), animated: false)
  }
  
  public func animatePath(speed: Double) -> GeoPathAnimator {
    let pathAnimator = GeoPathAnimator(mapView: mapView, pathToAnimate: path, speed: speed)
    pathAnimator.start()
    return pathAnimator
  }
  
  func regionForGeoPath(path: GeoPath) -> MKCoordinateRegion {
    var upper = CLLocationCoordinate2D(
      latitude: path.geoPoints[0].latitude,
      longitude: path.geoPoints[0].longitude)
    
    var lower = CLLocationCoordinate2D(
      latitude: path.geoPoints[0].latitude,
      longitude: path.geoPoints[0].longitude)
    
    for point: GeoPoint in path.geoPoints {
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
    if overlay is MKPolyline {
      let polylineRenderer = MKPolylineRenderer(overlay: overlay)
      
      if overlay.title! == MapDoodle.ANIMATE_OVERLAY_ID {
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 2.0
      }
      if overlay.title! == MapDoodle.TRACE_OVERLAY_ID {
        polylineRenderer.strokeColor = UIColor.redColor()
        polylineRenderer.lineWidth = 1.0
      }
      return polylineRenderer
    }
    
    return MKPolylineRenderer()
  }
}