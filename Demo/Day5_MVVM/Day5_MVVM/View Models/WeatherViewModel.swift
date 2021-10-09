//
//  WeatherViewModel.swift
//  Day5_MVVM
//
//  Created by 亿存 on 2020/7/10.
//  Copyright © 2020 亿存. All rights reserved.
//

import Foundation

// 1
import UIKit.UIImage
// 2
public class WeatherViewModel {
    
    let locationName = Box("Loading...")
    
    private let geocoder = LocationGeocoder()
    private static let defaultAddress = "Washington DC"
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()
    
    let date = Box(" ")
    
    private let tempFormatter: NumberFormatter = {
        let tempFormatter = NumberFormatter()
        tempFormatter.numberStyle = .none
        return tempFormatter
    }()
    
    let icon: Box<UIImage?> = Box(nil)  //no image initially
    let summary = Box(" ")
    let forecastSummary = Box(" ")
    
    func changeLocation(to newLocation: String) {
        
        self.locationName.value = "Not found"
        self.date.value = ""
        self.icon.value = nil
        self.summary.value = ""
        self.forecastSummary.value = ""
        
        
        locationName.value = "Loading..."
        geocoder.geocode(addressString: newLocation) { [weak self] locations in
            guard let self = self else { return }
            if let location = locations.first {
                self.locationName.value = location.name
                self.fetchWeatherForLocation(location)
                return
            }
        }
    }
    
    private func fetchWeatherForLocation(_ location: Location) {
        WeatherbitService.weatherDataForLocation(
            latitude: location.latitude,
            longitude: location.longitude) { [weak self] (weatherData, error) in
                guard let self = self, let weatherData = weatherData else {
                    return
                }
                self.date.value = self.dateFormatter.string(from: weatherData.date)
                
                self.icon.value = UIImage(named: weatherData.iconName)
                let temp = self.tempFormatter
                  .string(from: weatherData.currentTemp as NSNumber) ?? ""
                self.summary.value = "\(weatherData.description) - \(temp)℉"
                self.forecastSummary.value = "\nSummary: \(weatherData.description)"
        }
    }
    
    init() {
        changeLocation(to: Self.defaultAddress)
    }
}
