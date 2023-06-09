//
//  MainControllerViewModelTests.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp
import CoreLocation

final class MainControllerViewModelTests: XCTestCase {

    var vm: MainControllerViewModel!
    
    override func setUp() {
        super.setUp()
        let api = WeatherAPIMock()
        vm = MainControllerViewModel(api: api)
    }
    
    override func tearDown() {
        super.tearDown()
        vm = nil
    }
    
    func testSearchWeatherByLocationSuccess() async {
        let api = vm.api as! WeatherAPIMock
        let expectation = XCTestExpectation(description: "Search Weather By Location")
        
        var weatherData: WeatherModel?
        
        vm.handleState = { state in
            if case MainControllerViewModel.State.success(let result) = state {
                weatherData = result
                expectation.fulfill()
            }
        }
        
        await vm.searchWeather(for: "Atlanta")
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(api.getWeatherByCityCounter, 1, "getWeatherByCity shall only be called once")
        guard let weatherData = weatherData else { return }
        XCTAssertEqual(UserDefaults.standard.string(forKey: UserDefaults.Key.lastSearchedLocation), "Atlanta")
        XCTAssertEqual(weatherData.name, "Atlanta")
        XCTAssertEqual(weatherData.coord.lat, 33.749)
        XCTAssertEqual(weatherData.coord.lon, -84.388)
        //TODO: Expand to verify all properties
    }

    func testSearchWeatherByCoordinateSuccess() async {
        let api = vm.api as! WeatherAPIMock
        let expectation = XCTestExpectation(description: "Search Weather By Coordinate")
        
        var weatherData: WeatherModel?
        
        vm.handleState = { state in
            if case MainControllerViewModel.State.success(let result) = state {
                weatherData = result
                expectation.fulfill()
            }
        }
        
        await vm.searchWeather(for: CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99))
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(api.getWeatherByCoordinateCounter, 1, "getWeatherByCity shall only be called once")
        guard let weatherData = weatherData else { return }
        XCTAssertEqual(UserDefaults.standard.string(forKey: UserDefaults.Key.lastSearchedLocation), "Zocca")
        XCTAssertEqual(weatherData.name, "Zocca")
        XCTAssertEqual(weatherData.coord.lat, 44.34)
        XCTAssertEqual(weatherData.coord.lon, 10.99)
        //TODO: Expand to verify all properties
    }
}
