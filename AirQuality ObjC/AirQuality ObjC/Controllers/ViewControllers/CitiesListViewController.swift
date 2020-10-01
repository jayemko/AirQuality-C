//
//  CitiesListViewController.swift
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class CitiesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var country: String?
    var state: String?
    var cities: [String] = [] {
        didSet {
            updateTableView()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let state = state,
              let country = country else { return }
        
        DVMCityAirQualityController.fetchSupportedCities(inState: state, country: country) { (fetchedCities) in
            self.cities = fetchedCities
        }
    }
    
    // MARK: - Helpers
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Sources

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"cityCell") else { return UITableViewCell() }
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCityDetailSegue") {
            guard let destinationVC = segue.destination as? CityDetailsViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedCity = cities[indexPath.row]
            destinationVC.city = selectedCity
            destinationVC.country = country
            destinationVC.state = state
        }
    }
}
