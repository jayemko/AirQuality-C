//
//  CityDetailsViewController.swift
//  AirQuality ObjC
//
//  Created by Jason Koceja on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    
    // MARK: - Properties
    
    var country: String?
    var state: String?
    var city: String?
    var aqiCity: CityAirQuality?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let city = city,
              let state = state,
              let country = country else { return }
        
        DVMCityAirQualityController.fetchData(forCity: city, state: state, country: country) { (aqiCity) in
            self.aqiCity = aqiCity
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Helpers
    
    func updateViews() {
        guard let aqiCity = aqiCity else { return }
 
        let farenheit = convertCelsiusToFarenheit(celcius: aqiCity.weather.temperature)
        let mph = metersPerSecondToMPH(mps: aqiCity.weather.windSpeed)
        cityNameLabel.text = aqiCity.city
        stateNameLabel.text = aqiCity.state
        countryNameLabel.text = aqiCity.country
        aqiLabel.text = String("\(aqiCity.pollution.airQualityIndex)")
        temperatureLabel.text = String("\(farenheit)°F" )
        humidityLabel.text = String("\(aqiCity.weather.humidity)%")
        windspeedLabel.text = String("\(mph)")
            
    }
    
    func convertCelsiusToFarenheit(celcius: NSInteger) -> NSInteger {
        return celcius * 9 / 5 + 32
    }
    
    func metersPerSecondToMPH(mps:NSInteger) -> NSInteger {
        let metric = Measurement(value: Double(mps), unit: UnitSpeed.metersPerSecond)
        let mph = metric.converted(to: UnitSpeed.milesPerHour)
        return NSInteger(mph.value)
    }
}
