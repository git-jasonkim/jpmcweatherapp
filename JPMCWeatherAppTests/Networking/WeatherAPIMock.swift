//
//  WeatherAPIMock.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp
import CoreLocation

final class WeatherAPIMock: WeatherAPIImpl {
    var getWeatherByCityCounter = 0
    var getWeatherByCoordinateCounter = 0
    var getWeatherIconCounter = 0
    
    func getWeather(for location: String) async -> Result<JPMCWeatherApp.WeatherModel, JPMCWeatherApp.NetworkingManager.NetworkingError> {
        getWeatherByCityCounter += 1
        guard
            let url = Bundle.main.url(forResource: "SampleWeatherDataAtlanta", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return .failure(.invalidData)
        }

        do {
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return .success(weatherResponse.convertToWeatherModel())
        } catch {
            return .failure(.failedToDecode(error: error))
        }
    }
    
    func getWeather(for coordinate: CLLocationCoordinate2D) async -> Result<JPMCWeatherApp.WeatherModel, JPMCWeatherApp.NetworkingManager.NetworkingError> {
        getWeatherByCoordinateCounter += 1
        guard
            let url = Bundle.main.url(forResource: "SampleWeatherDataLatLon", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return .failure(.invalidData)
        }

        do {
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return .success(weatherResponse.convertToWeatherModel())
        } catch {
            return .failure(.failedToDecode(error: error))
        }
    }
}
