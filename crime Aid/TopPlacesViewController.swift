//
//  TopPlacesViewController.swift
//  crime Aid
//
//  Created by Cassy on 11/10/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class TopPlacesViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    var safeArea : UILayoutGuide!
    var placesChosen = 0;
    let places = ["First St. NE, Washington, DC", "1600 Pennsylvania Ave NW, Washington, DC", "Lincoln Memorial, 2 Lincoln Memorial Cir NW, Washington, DC", "2 15th St NW, Washington, DC", "Vietnam Veterans Memorial, 5 Henry Bacon Dr NW, Washington, DC", "600 Independence Ave SW, Washington, DC", "Constitution Ave. NW, Washington, DC", "10th St. & Consitution Ave. NW, Washington, DC", "3001 Connecticut Ave NW, Washington, DC", "1300 Constitution Ave NW, Washington, DC", "16 E Basin Dr SW, Washington, DC", "Arlington, VA", "555 Pennsylvania Ave NW, Washington, DC", "700 L'Enfant Plaza SW, Washington, DC", "1400 Constitution Ave NW, Washington, DC", "3101 Wisconsin Ave NW, Washington, DC", "Georgetown, Washington, DC"]
    let coordinates : [(CLLocationDegrees, CLLocationDegrees)] = [(38.8898214, -77.0074088), (38.8976763, -77.0365298), (38.8892686, -77.050176), (38.8894838, -77.0352791), (38.8912933, -77.04771319999999), (38.88816010000001, -77.0198679), (38.891298, -77.019965), (38.8912662, -77.0260654), (38.9296156, -77.0497844), (38.89127930000001, -77.03005089999999), (38.88138060000001, -77.0364536), (38.8783252, -77.068671), (38.8930396, -77.0192849), (38.8838607, -77.0254573), (38.8910644, -77.032614), (38.9305946, -77.0707808), (38.9097057, -77.06535650000001)]
    var selectedPlaces = [CLLocationCoordinate2D]()
    var completionHandler: (([CLLocationCoordinate2D]) -> [CLLocationCoordinate2D])?
    weak var delegate: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        safeArea = self.view.layoutMarginsGuide
        tableView.dataSource = self
        tableView.delegate = self
        setUpTable()
    }
    
    private func setUpTable(){
        self.view.addSubview(tableView)
        tableView.allowsMultipleSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel()
        headerView.backgroundColor = .lavender
        headerView.text = "Choose 4 places to visit"
        headerView.font = UIFont(name: "HelveticaNeue-Light", size: 38)
        headerView.textColor = .white
        headerView.textAlignment = .center
        return headerView
    }
}

extension TopPlacesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = .lavender
        cell.textLabel?.text = "\(places[indexPath.row])"
        return cell
    }
    
    func tableview(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if placesChosen >= 4{
            _ = completionHandler!(selectedPlaces)
            dismiss(animated: true, completion: nil)
        }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let current = tableView.cellForRow(at: indexPath)
        let indexcellLabel = places.firstIndex(of: (current?.textLabel!.text)!)!
        let coordinateTuple = coordinates[indexcellLabel]
        let transformed = CLLocationCoordinate2D(latitude: coordinateTuple.0, longitude: coordinateTuple.1)
        let contains = selectedPlaces.contains { ($0.latitude == transformed.latitude) &&  }
//        var contains = selectedPlaces.contains { element in
//            if (transformed.latitude == element.latitude) && (transformed.longitude == element.longitude){
//                return true
//            }
//            else{
//                return false
//            }
        }
    
        if !contains{
            selectedPlaces.append(transformed)
            print("Added a place to list")
            placesChosen += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        let current = tableView.cellForRow(at: indexPath)
        let indexcellLabel = places.firstIndex(of: (current?.textLabel!.text)!)!
        let coordinateTuple = coordinates[indexcellLabel]
        let transformed = CLLocationCoordinate2D(latitude: coordinateTuple.0, longitude: coordinateTuple.1)
        let contains = selectedPlaces.contains { element in
        if (transformed.latitude == element.latitude) && (transformed.longitude == element.longitude){
            return true
        }
        else{
            return false
        }
    }
               
        if contains{
            selectedPlaces.remove(at: indexPath.row)
        }
    }
}
