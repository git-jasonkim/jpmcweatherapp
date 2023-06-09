//
//  WeatherExtraDetailModel.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation

struct WeatherExtraDetailModel {
    let humidity: String
    let windSpeed: String
    let feelsLike: String
    
    init(humidity: Int, windSpeed: Double, feelsLike: Double) {
        self.humidity = "\(humidity)%"
        self.windSpeed = "\(windSpeed) mph"
        self.feelsLike = "\(feelsLike)ºF"
    }
    
}
