//
//  Doodle.swift
//  Pods
//
//  Created by Vorn Mom on 8/2/16.
//
//

import Foundation
import MapKit

public protocol Doodle : class {
  var points: [GeoPoint] { get }
  var bounds: [GeoPoint] { get }
  var id: String! { get set }
  func draw(doodle: DoodleContext)
  func remove()
  func setupPolylineRenderer(polyline: MKPolyline) -> MKPolylineRenderer?
}