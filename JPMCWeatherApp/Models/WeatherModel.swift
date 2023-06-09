//
//  WeatherModel.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation

struct WeatherModel {
    let coord: Coordinate
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Cloud
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    
    init(response: WeatherResponse) {
        self.coord = Coordinate(response: response.coord)
        self.weather = response.weather.map { Weather(response: $0) }
        self.main = Main(response: response.main)
        self.visibility = response.visibility
        self.wind = Wind(response: response.wind)
        self.clouds = Cloud(response: response.clouds)
        self.dt = response.dt
        self.sys = Sys(response: response.sys)
        self.timezone = response.timezone
        self.id = response.id
        self.name = response.name
    }
    
    struct Coordinate {
        let lat: Double
        let lon: Double
        
        init(response: WeatherResponse.CoordinateData) {
            self.lat = response.lat
            self.lon = response.lon
        }
    }
    
    struct Weather {
        let id: Int
        let main: String
        let description: String
        let icon: String
        
        init(response: WeatherResponse.WeatherData) {
            self.id = response.id
            self.main = response.main
            self.description = response.description
            self.icon = response.icon
        }
    }
    
    struct Main {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?
        
        init(response: WeatherResponse.MainData) {
            self.temp = response.temp
            self.feelsLike = response.feelsLike
            self.tempMin = response.tempMin
            self.tempMax = response.tempMax
            self.pressure = response.pressure
            self.humidity = response.humidity
            self.seaLevel = response.seaLevel
            self.grndLevel = response.grndLevel
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
        
        init(response: WeatherResponse.WindData) {
            self.speed = response.speed
            self.deg = response.deg
            self.gust = response.gust
        }
    }
    
    struct Cloud: Codable {
        let all: Int
        
        init(response: WeatherResponse.CloudData) {
            self.all = response.all
        }
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
        
        init(response: WeatherResponse.SysData) {
            self.type = response.type
            self.id = response.id
            self.country = response.country
            self.sunrise = response.sunrise
            self.sunset = response.sunset
        }
    }

}
