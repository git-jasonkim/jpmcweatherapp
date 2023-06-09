//
//  WeatherAPI.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation
import CoreLocation

struct WeatherAPI: WeatherAPIImpl {
    private let api: NetworkingManagerImpl
    
    init(api: NetworkingManagerImpl = NetworkingManager.shared) {
        self.api = api
    }
    
    func getWeather(for location: String) async -> Result<WeatherModel, NetworkingManager.NetworkingError> {
        do {
            let response = try await api.request(.getWeatherByCity(name: location), type: WeatherResponse.self)
            return .success(response.convertToWeatherModel())
        } catch {
            return .failure(error as? NetworkingManager.NetworkingError ?? .custom(error: error))
        }
    }
    
    func getWeather(for coordinate: CLLocationCoordinate2D) async -> Result<WeatherModel, NetworkingManager.NetworkingError> {
        do {
            let response = try await api.request(.getWeatherByCoordinate(coordinate: coordinate), type: WeatherResponse.self)
            return .success(response.convertToWeatherModel())
        } catch {
            return .failure(error as? NetworkingManager.NetworkingError ?? .custom(error: error))
        }
    }
    
}
