//
//  WeatherAPIImpl.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/7/23.
//

import Foundation
import CoreLocation

protocol WeatherAPIImpl {
    func getWeather(for location: String) async -> Result<WeatherModel, NetworkingManager.NetworkingError>
    func getWeather(for coordinate: CLLocationCoordinate2D) async -> Result<WeatherModel, NetworkingManager.NetworkingError>

}
