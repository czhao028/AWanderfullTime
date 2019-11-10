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
    let places = ["First St. NE, Washington, DC", "1600 Pennsylvania Ave NW, Washington, DC", "Lincoln Memorial, 2 Lincoln Memorial Cir NW, Washington, DC", "2 15th St NW, Washington, DC", "Vietnam Veterans Memorial, 5 Henry Bacon Dr NW, Washington, DC", "600 Independence Ave SW, Washington, DC", "Constitution Ave. NW, Washington, DC", "10th St. & Consitution Ave. NW, Washington, DC", "3001 Connecticut Ave NW, Washington, DC", "1300 Constitution Ave NW, Washington, DC", "16 E Basin Dr SW, Washington, DC", "Arlington, VA", "555 Pennsylvania Ave NW, Washington, DC", "700 L'Enfant Plaza SW, Washington, DC", "1400 Constitution Ave NW, Washington, DC", "3101 Wisconsin Ave NW, Washington, DC", "Georgetown, Washington, DC"]
    var selectedPlaces = [CLLocationCoordinate2D]()
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
}

extension TopPlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = .lavendar
        cell.textLabel?.text = "\(places[indexPath.row])"
        return cell
    }
    
    func tableview(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let current = tableView.cellForRow(at: indexPath)
    }
}
