//
//  WeatherResponse.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation

///response data: https://openweathermap.org/current
struct WeatherResponse: Codable {
    let coord: CoordinateData
    let weather: [WeatherData]
    let main: MainData
    let visibility: Int
    let wind: WindData
    let clouds: CloudData
    let dt: Int
    let sys: SysData
    let timezone: Int
    let id: Int
    let name: String

    struct CoordinateData: Codable {
        let lat: Double
        let lon: Double
    }
    
    struct WeatherData: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainData: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct WindData: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct CloudData: Codable {
        let all: Int
    }
    
    struct SysData: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }

    
    func convertToWeatherModel() -> WeatherModel {
        return WeatherModel(response: self)
    }
}
