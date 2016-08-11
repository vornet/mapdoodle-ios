//
//  DoodleContext.swift
//  Pods
//
//  Created by Vorn Mom on 8/2/16.
//
//

import Foundation
import MapKit

public class DoodleContext {
  var elapsedTime: Double = 0.0
  var mapView: MKMapView
  
  init(mapView: MKMapView) {
    self.mapView = mapView
  }
}