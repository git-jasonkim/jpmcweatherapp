//
//  MainControllerTests.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp

final class MainControllerTests: XCTestCase {

    var vc: MainController!
    var weatherData: WeatherModel!
    
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
            let api = WeatherAPIMock()
            let vm = MainControllerViewModel(api: api)
            self.vc = MainController(vm: vm)
            let _ = vc.view
        } catch {
            throw error
        }
    }
    
    override func tearDown() {
        super.tearDown()
        vc = nil
        weatherData = nil
    }
    
    func testVMSuccessState() {
        vc.searchTextField.text = "1"
        vc.vm.handleState?(.success(data: weatherData))
        XCTAssertEqual(vc.searchTextField.text, weatherData.name)
        XCTAssertEqual(vc.statusLabel.text, "Status: success")
    }
    
    func testVMLoadingState() {
        vc.searchTextField.text = "1"
        vc.vm.handleState?(.loading)
        XCTAssertEqual(vc.searchTextField.text, "1")
        XCTAssertEqual(vc.statusLabel.text, "Status: loading")
    }
    
    func testVMFailureState() {
        vc.searchTextField.text = "1"
        vc.vm.handleState?(.failure(error: "error"))
        XCTAssertEqual(vc.searchTextField.text, "1")
        XCTAssertEqual(vc.statusLabel.text, "Status: error")
    }
    
    //Tests UI defaults
    
}
