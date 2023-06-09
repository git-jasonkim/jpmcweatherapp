//
//  WeatherViewModel.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

class WeatherViewModel {
    
    private let weatherData: WeatherModel
    private(set) var extraDetails: WeatherExtraDetailModel
    
    init(weatherData: WeatherModel) {
        self.weatherData = weatherData
        self.extraDetails = WeatherExtraDetailModel(humidity: weatherData.main.humidity, windSpeed: weatherData.wind.speed, feelsLike: weatherData.main.feelsLike)
    }
    
    public var icon: String? {
        return weatherData.weather.first?.icon
    }
    
    public func getWeatherAttributedText() -> NSAttributedString {
        var attributedText = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        
        attributedText = NSMutableAttributedString(string: "\(weatherData.name)", attributes: attributes)
        attributedText.append(NSAttributedString(string: "\n\(weatherData.main.temp)ºF", attributes: attributes))

        if let weather = weatherData.weather.first {
            attributedText.append(NSAttributedString(string: " | \(weather.description)", attributes: attributes))
        }
        attributedText.append(NSAttributedString(string: "\nH: \(weatherData.main.tempMax)ºF | L: \(weatherData.main.tempMin)ºF", attributes: attributes))

        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    
    public func getExtraDetailAttributedText() -> NSAttributedString {

        var attributedText = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        attributedText = NSMutableAttributedString(string: "Humidity: \(extraDetails.humidity)", attributes: attributes)
        attributedText.append(NSAttributedString(string: "\nWind: \(extraDetails.windSpeed)", attributes: attributes))
        attributedText.append(NSAttributedString(string: "\nFeels like: \(extraDetails.feelsLike)", attributes: attributes))

        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    
}
