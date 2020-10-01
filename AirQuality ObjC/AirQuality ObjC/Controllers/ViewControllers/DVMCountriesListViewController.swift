//
//  DVMCountriesListViewController.swift
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class DVMCountriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var countries: [String] = [] {
        didSet {
            updateTableView()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DVMCityAirQualityController.fetchSupportedCountries { (fetchedCountries) in
            self.countries = fetchedCountries
        }
    }
    
    // MARK: - Helpers
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"countryCell") else { return UITableViewCell() }
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toStatesVCSegue") {
            guard let destinationVC = segue.destination as? StatesListViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedCountry = countries[indexPath.row]
            destinationVC.country = selectedCountry;
        }
    }
    
}
