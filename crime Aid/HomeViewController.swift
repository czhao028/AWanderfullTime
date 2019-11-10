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
import GooglePlaces

class HomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var resultViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultText: UITextView?
    let filter = GMSAutocompleteFilter()
    var hours = -1
    var selectPlacesButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
        placesClient = GMSPlacesClient.shared()

        let camera = GMSCameraPosition.camera(withLatitude: 0,
                                              longitude: 0,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.compassButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        resultViewController = GMSAutocompleteResultsViewController()
        resultViewController?.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        let northWest = CLLocationCoordinate2DMake(38.934346, -77.119746)
        let southEast = CLLocationCoordinate2DMake(38.892951, -76.909843)
        resultViewController?.autocompleteBounds = GMSCoordinateBounds(coordinate: northWest, coordinate: southEast)
        searchController = UISearchController(searchResultsController: resultViewController)
        searchController?.searchResultsUpdater = resultViewController
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))

        //let margins = self.view.layoutMarginsGuide
        selectPlacesButton = UIButton(frame: .zero)
        selectPlacesButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectPlacesButton)
        NSLayoutConstraint.activate([selectPlacesButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
                                     selectPlacesButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 810),
                                     selectPlacesButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 160),
                                     selectPlacesButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -160)])

        selectPlacesButton.backgroundColor = .lavender
        selectPlacesButton.layer.cornerRadius = 30
        selectPlacesButton.layer.masksToBounds = true
        selectPlacesButton.setTitle("+", for: .normal)
        selectPlacesButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        selectPlacesButton.titleLabel?.adjustsFontSizeToFitWidth = true
        selectPlacesButton.tintColor = .white
        selectPlacesButton.addTarget(self, action: #selector(plusPressed(_:)), for: .touchUpInside)
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let lastLoc = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: lastLoc.coordinate.latitude, longitude: lastLoc.coordinate.longitude, zoom: zoomLevel)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lastLoc.coordinate.latitude, longitude: lastLoc.coordinate.longitude))
        marker.map = mapView
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: zoomLevel)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        marker.map = mapView
        mapView.camera = camera
        mapView.animate(to: camera)
        self.searchController?.dismiss(animated: true) {
            let hourAlert = UIAlertController(title: "Hours to spend here?", message: "How many hours would you like to spend here?", preferredStyle: .alert)
            hourAlert.addTextField { (textField) in
                textField.placeholder = "Enter hours"
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = hourAlert.textFields![0] as UITextField
                guard let hour = firstTextField.text else { return }
                self.store(hour)
                print("Hours in closure: \(self.hours)")
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert -> Void in
                return
            })
            
            hourAlert.addAction(saveAction)
            hourAlert.addAction(cancelAction)

            self.present(hourAlert, animated: true, completion: nil)
        }
    }
    
    func store(_ hours: String){
        self.hours = Int(hours) ?? 0
    }
       
       func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    @IBAction func plusPressed(_ sender: UIButton){
        let topPlaces = TopPlacesViewController()
        topPlaces.modalPresentationStyle = .overFullScreen
        show(topPlaces, sender: self)
    }
}
