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
  
  var mapDoodler: MapDoodler!
  var doodles: [Doodle]!
  var visibleDoodle: Int = 0
  
  @IBAction func switchButtonProessed(sender: UIButton) {
    visibleDoodle += 1
    visibleDoodle = visibleDoodle % (doodles.count + 1)
    
    if visibleDoodle < doodles.count {
      mapDoodler.zoomToFitDoodle(doodles[visibleDoodle], padding: 0, shouldAnimate: true, shouldChangeBearing: true)
    } else {
      mapDoodler.zoomFitAllDoodles(150, shouldAnimate: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapDoodler = MapDoodler(mapView: mapView, refreshRate: 500)
    
    let pathDoodleStyle = AnimatedPathDoodleStyle()
    pathDoodleStyle.thickness = 10
    pathDoodleStyle.color = UIColor.blueColor()
    pathDoodleStyle.tracerThickness = 5.0
    pathDoodleStyle.tracerColor = UIColor.grayColor()
    pathDoodleStyle.speed = 60.0
  
    // Shining Sea Bikeway
    let shiningSeaBikewayPoints: [GeoPoint] = [
      GeoPoint(latitude: 41.551490, longitude: -70.627179),
      GeoPoint(latitude: 41.550410, longitude: -70.627761),
      GeoPoint(latitude: 41.534456, longitude: -70.641752),
      GeoPoint(latitude: 41.534319, longitude: -70.642047),
      GeoPoint(latitude: 41.534032, longitude: -70.642455),
      GeoPoint(latitude: 41.531242, longitude: -70.645581),
      GeoPoint(latitude: 41.524383, longitude: -70.653310),
      GeoPoint(latitude: 41.524383, longitude: -70.653310),
      GeoPoint(latitude: 41.523319, longitude: -70.655396),
      GeoPoint(latitude: 41.523034, longitude: -70.656157),
      GeoPoint(latitude: 41.522540, longitude: -70.659166),
      GeoPoint(latitude: 41.522524, longitude: -70.661014),
      GeoPoint(latitude: 41.522825, longitude: -70.663299),
      GeoPoint(latitude: 41.523331, longitude: -70.665032),
      GeoPoint(latitude: 41.523395, longitude: -70.666019),
      GeoPoint(latitude: 41.523001, longitude: -70.668535),
      GeoPoint(latitude: 41.523049, longitude: -70.668605),
      GeoPoint(latitude: 41.523061, longitude: -70.668922),
      GeoPoint(latitude: 41.523001, longitude: -70.669019),
      GeoPoint(latitude: 41.523017, longitude: -70.669158),
      GeoPoint(latitude: 41.523101, longitude: -70.669233)
    ]
    
    // Cape Cod Canal Service Road
    let capeCodeCanalServiceRoadPoints: [GeoPoint] = [
      GeoPoint(latitude: 41.743239, longitude:  -70.613286),
      GeoPoint(latitude: 41.745799, longitude:  -70.601731),
      GeoPoint(latitude: 41.747392, longitude:  -70.594167),
      GeoPoint(latitude: 41.749841, longitude:  -70.587451),
      GeoPoint(latitude: 41.755180, longitude:  -70.577988),
      GeoPoint(latitude: 41.758533, longitude:  -70.574018),
      GeoPoint(latitude: 41.760342, longitude:  -70.572505),
      GeoPoint(latitude: 41.766240, longitude:  -70.568664),
      GeoPoint(latitude: 41.768489, longitude:  -70.566808),
      GeoPoint(latitude: 41.771314, longitude:  -70.563579),
      GeoPoint(latitude: 41.771521, longitude:  -70.563517),
      GeoPoint(latitude: 41.771606, longitude:  -70.563392),
      GeoPoint(latitude: 41.771658, longitude:  -70.563126),
      GeoPoint(latitude: 41.774158, longitude:  -70.558663),
      GeoPoint(latitude: 41.776142, longitude:  -70.553008),
      GeoPoint(latitude: 41.776824, longitude:  -70.549567),
      GeoPoint(latitude: 41.777240, longitude:  -70.545823),
      GeoPoint(latitude: 41.777280, longitude:  -70.545431),
      GeoPoint(latitude: 41.777160, longitude:  -70.540834),
      GeoPoint(latitude: 41.773926, longitude:  -70.512234),
      GeoPoint(latitude: 41.774070, longitude:  -70.511566),
      GeoPoint(latitude: 41.774320, longitude:  -70.511046),
      GeoPoint(latitude: 41.774696, longitude:  -70.510429),
      GeoPoint(latitude: 41.774846, longitude:  -70.509933),
      GeoPoint(latitude: 41.775782, longitude:  -70.503557),
      GeoPoint(latitude: 41.775812, longitude:  -70.502865),
      GeoPoint(latitude: 41.775664, longitude:  -70.501186),
      GeoPoint(latitude: 41.775802, longitude:  -70.500440),
      GeoPoint(latitude: 41.776408, longitude:  -70.498739),
      GeoPoint(latitude: 41.776982, longitude:  -70.497967)
    ]
    
    let shiningSeaBikewayDoodle = mapDoodler.addAnimatedPathDoodle(pathDoodleStyle, points: shiningSeaBikewayPoints)
    let capeCodeCanalServiceRoadDoodle = mapDoodler.addAnimatedPathDoodle(pathDoodleStyle, points: capeCodeCanalServiceRoadPoints)
    
    doodles = [shiningSeaBikewayDoodle, capeCodeCanalServiceRoadDoodle ]
    visibleDoodle = doodles.count
    
    mapDoodler.zoomFitAllDoodles(150, shouldAnimate: false)
    
    //mapDoodle.addPath(shiningSeaBikeway)
    //mapDoodle.animatePath(100.0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

