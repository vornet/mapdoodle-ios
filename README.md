# MapDoodle

[![CI Status](http://img.shields.io/travis/vornet/mapdoodle-ios.svg?style=flat)](https://travis-ci.org/vornet/mapdoodle-ios)
[![Version](https://img.shields.io/cocoapods/v/MapDoodle.svg?style=flat)](http://cocoapods.org/pods/MapDoodle)
[![License](https://img.shields.io/cocoapods/l/MapDoodle.svg?style=flat)](http://cocoapods.org/pods/MapDoodle)
[![Platform](https://img.shields.io/cocoapods/p/MapDoodle.svg?style=flat)](http://cocoapods.org/pods/MapDoodle)

![Screenshots](https://raw.githubusercontent.com/vornet/mapdoodle-ios/master/art/mapdoodledemo.gif)

iOS library to create common map animations for MapKit and other providers. Note, work-in-progress.

Shameless Plug: This library was written for my skiing & snowboarding app, Mogul Bunny.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MapDoodle is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MapDoodle"
```

## Basic Usage

Once you get an instance of MKMapView, just pass it along to an instance of MapDoodler.
Then, add your waypoints to a `GeoPath`.

```swift
class ViewController: UIViewController {
  @IBOutlet var mapView: MKMapView!
  var mapDoodler: MapDoodler!

  override func viewDidLoad() {
    super.viewDidLoad()

    mapDoodler = MapDoodler(mapView: mapView, refreshRate: 500)

    let pathDoodleStyle = AnimatedPathDoodleStyle()
    pathDoodleStyle.thickness = 10
    pathDoodleStyle.color = UIColor.blueColor()
    pathDoodleStyle.tracerThickness = 5.0
    pathDoodleStyle.tracerColor = UIColor.grayColor()
    pathDoodleStyle.speed = 250.0

    // Shining Sea Bikeway
    let shiningSeaBikewayPoints: [GeoPoint] = [
      GeoPoint(latitude: 41.551490, longitude: -70.627179),
      GeoPoint(latitude: 41.550410, longitude: -70.627761),
      GeoPoint(latitude: 41.534456, longitude: -70.641752),
      GeoPoint(latitude: 41.534319, longitude: -70.642047),
      GeoPoint(latitude: 41.534032, longitude: -70.642455),
      GeoPoint(latitude: 41.531242, longitude: -70.645581),
      GeoPoint(latitude: 41.524383, longitude: -70.653310),
      GeoPoint(latitude: 41.524383, longitude: -70.653310)
    ]

    let shiningSeaBikewayDoodle = mapDoodler.addAnimatedPathDoodle(pathDoodleStyle, points: shiningSeaBikewayPoints)
    mapDoodler.zoomFitAllDoodles(150, shouldAnimate: false)
  }
}

```

Static (not animated) path doodles can also be added.

```swift

let pathDoodleStyle = PathDoodleStyle()
pathDoodleStyle.thickness = 10
pathDoodleStyle.color = UIColor.blueColor()

let shiningSeaBikewayPoints: [GeoPoint] = [
// ...
]

let shiningSeaBikewayDoodle = mapDoodler.addPathDoodle(pathDoodleStyle, points: shiningSeaBikewayPoints)


```

Doodles can be added at anytime (for example, via user interaction.)

The following is supported for doodle management:

```swift
let mapDoodler = MapDoodler(mapView: mapView, refreshRate: 500)
// Add a new doodle.
let doodle = mapDoodler.addPathDoodle(style: pathDoodleStyle, points: points)
// Assign a string ID to a doodle.
doodle.id = "foo"
// Later, you can retrieve the doodle by ID.
let doodle = mapDoodler.getDoodleById(id: "foo")
// Remove a doodle from the map
mapDoodler.removeDoodle(doodle)
// Zoom to fit a doodle.
mapDoodler.zoomToFitDoodle(doodle)
// Zoom to fit all doodles on the map.
mapDoodler.zoomToFitAllDoodles()
// Change the style of a doodle. Style must be for the correct doodle type, otherwise no-op.
doodle.setStyle(style: newStyle)

```

## Author

Vorn Mom, vorn@vorn.us

## License

MapDoodle is available under the MIT license. See the LICENSE file for more info.
