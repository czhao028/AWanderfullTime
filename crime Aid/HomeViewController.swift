//
//  HomeViewController.swift
//  crime Aid
//
//  Created by Cassy on 11/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import GoogleMaps

class HomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    weak var mapView: GMSMapView!
    weak var marker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        let camera = GMSCameraPosition.camera(withLatitude:  , longitude:, zoom:14)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: <#GMSCameraPosition#>)
        self.mapView = mapView
        locationManager.pausesLocationUpdatesAutomatically = true
        self.view = mapView
                
        let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
                marker.title = "Sydney"
                marker.snippet = "Australia"
        marker.map = self.mapView
        self.marker = marker
    }
    
//    override func loadView() {
//        super.loadView()
//        self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//
//        let camera = GMSCameraPosition()
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        self.mapView = mapView
//        locationManager.pausesLocationUpdatesAutomatically = true
//        self.view = mapView
//
//        let marker = GMSMarker()
//        //marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
////        marker.title = "Sydney"
////        marker.snippet = "Australia"
//        marker.map = self.mapView
//        self.marker = marker
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
       // guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let lastLoc = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (lastLoc?.coordinate.latitude)!, longitude:(lastLoc?.coordinate.longitude)!, zoom:14)
        self.marker.position = CLLocationCoordinate2D(latitude: (lastLoc?.coordinate.latitude)!, longitude: (lastLoc?.coordinate.longitude)!)
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
}
