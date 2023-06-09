//
//  WeatherViewModelTests.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp

final class WeatherViewModelTests: XCTestCase {

    var vm: WeatherViewModel!
    var weatherData: WeatherModel!
    var extraDetails: WeatherExtraDetailModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        guard
            let url = Bundle.main.url(forResource: "SampleWeatherDataAtlanta", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            throw NetworkingManager.NetworkingError.invalidData
        }

        do {
            let decoder = JSONDecoder()
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            let weatherData = weatherResponse.convertToWeatherModel()
            self.weatherData = weatherData
            self.extraDetails = WeatherExtraDetailModel(humidity: weatherData.main.humidity, windSpeed: weatherData.wind.speed, feelsLike: weatherData.main.feelsLike)
            self.vm = WeatherViewModel(weatherData: weatherData)
        } catch {
            throw error
        }
    }

    func testGetWeatherAttributedText() {
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
        
        XCTAssertEqual(vm.getWeatherAttributedText(), attributedText)
    }

    func testGetExtraDetailAttributedText() {
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
        
        XCTAssertEqual(vm.getExtraDetailAttributedText(), attributedText)
    }
}
