//
//  ViewController.swift
//  MapDoodle
//
//  Created by Vorn Mom on 6/30/16.
//  Copyright © 2016 Moonberry Tech, LLC. All rights reserved.
//

import UIKit
import MapKit
import MapDoodle

class ViewController: UIViewController {

  @IBOutlet var mapView: MKMapView!
  
  var mapDoodle: MapDoodle!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapDoodle = MapDoodle(mapView: mapView)
  
    // Shining Sea Bikeway
    let shiningSeaBikeway = GeoPath()
    shiningSeaBikeway.addPoint(41.551490, longitude: -70.627179)
    shiningSeaBikeway.addPoint(41.550410, longitude: -70.627761)
    shiningSeaBikeway.addPoint(41.534456, longitude: -70.641752)
    shiningSeaBikeway.addPoint(41.534319, longitude: -70.642047)
    shiningSeaBikeway.addPoint(41.534032, longitude: -70.642455)
    shiningSeaBikeway.addPoint(41.531242, longitude: -70.645581)
    shiningSeaBikeway.addPoint(41.524383, longitude: -70.653310)
    shiningSeaBikeway.addPoint(41.524383, longitude: -70.653310)
    shiningSeaBikeway.addPoint(41.523319, longitude: -70.655396)
    shiningSeaBikeway.addPoint(41.523034, longitude: -70.656157)
    shiningSeaBikeway.addPoint(41.522540, longitude: -70.659166)
    shiningSeaBikeway.addPoint(41.522524, longitude: -70.661014)
    shiningSeaBikeway.addPoint(41.522825, longitude: -70.663299)
    shiningSeaBikeway.addPoint(41.523331, longitude: -70.665032)
    shiningSeaBikeway.addPoint(41.523395, longitude: -70.666019)
    shiningSeaBikeway.addPoint(41.523001, longitude: -70.668535)
    shiningSeaBikeway.addPoint(41.523049, longitude: -70.668605)
    shiningSeaBikeway.addPoint(41.523061, longitude: -70.668922)
    shiningSeaBikeway.addPoint(41.523001, longitude: -70.669019)
    shiningSeaBikeway.addPoint(41.523017, longitude: -70.669158)
    shiningSeaBikeway.addPoint(41.523101, longitude: -70.669233)
    
    mapDoodle.addPath(shiningSeaBikeway)
    mapDoodle.animatePath(100.0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

