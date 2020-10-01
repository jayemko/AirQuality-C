//
//  StatesListViewController.swift
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class StatesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var country: String?
    var states: [String] = [] {
        didSet {
            updateTableView()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let country = country else { return }
        DVMCityAirQualityController.fetchSupportedStates(inCountry:country, completion: { (fetchedStates) in
            self.states = fetchedStates
        })
    }
    
    // MARK: - Helpers
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count > 0 ? states.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"stateCell") else { return UITableViewCell() }
        if (states.count > 0) {
            cell.textLabel?.text = states[indexPath.row]
            cell.isUserInteractionEnabled = true
        }else {
            cell.textLabel?.text = "No states found"
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCitiesVCSegue") {
            guard let destinationVC = segue.destination as? CitiesListViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedState = states[indexPath.row]
            destinationVC.state = selectedState;
            destinationVC.country = country
        }
    }
    
}
