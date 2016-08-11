//
//  PathDoodle.swift
//  Pods
//
//  Created by Vorn Mom on 8/2/16.
//
//

import Foundation
import MapKit

public class PathDoodle : Doodle {
  public var id: String!
  public var points: [GeoPoint]
  
  var style: PathDoodleStyle
  
  var shouldRedraw: Bool = true
  var isBeingRemoved: Bool = false
  
  private var mapView: MKMapView!
  private var polyline: MKPolyline!
  
  init(style: PathDoodleStyle, points: [GeoPoint]) {
    self.style = style
    self.points = points
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
      }
      
      var coordinates = self.points.map({ geoPoint -> CLLocationCoordinate2D in CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)})
    
      self.polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
      context.mapView.addOverlay(self.polyline)
    }
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
  
  public func setupPolylineRenderer(polyline: MKPolyline) -> MKPolylineRenderer? {
    var polylineRenderer: MKPolylineRenderer? = nil
    
    if self.polyline === polyline {
      polylineRenderer = MKPolylineRenderer(overlay: polyline)
      polylineRenderer!.strokeColor = style.color
      polylineRenderer!.lineWidth = CGFloat(style.thickness / 2.5)
    }
    
    return polylineRenderer
  }

}