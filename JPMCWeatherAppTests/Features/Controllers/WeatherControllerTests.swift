//
//  WeatherControllerTests.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp

final class WeatherControllerTests: XCTestCase {

    var vc: WeatherController!
    var vm: WeatherViewModel!
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
            self.vm = WeatherViewModel(weatherData: weatherData)
            let api = ImageRetrieverMock()
            self.vc = WeatherController(api: api, cache: ImageCache.shared)
            let _ = vc.view
        } catch {
            throw error
        }
    }
    
    override func tearDown() {
        super.tearDown()
        vc = nil
        vm = nil
        weatherData = nil
    }

    func testWeatherViews() {
        XCTAssertEqual(WeatherController.WeatherViews.allCases.count, 2, "Currently, there shall only be two view types")
    }
    
    func testWeatherReuseIdentifiers() {
        XCTAssertEqual(WeatherController.ReuseId.weatherCell, "cWeatherCell")
        XCTAssertEqual(WeatherController.ReuseId.weatherExtraDetailCell, "cWeatherExtraDetailCell")
    }
    
    func testNumberOfItemsInSectionWithNilVM() {
        XCTAssertEqual(vc.collectionView.numberOfItems(inSection: 0), 0)
    }
    
    func testNumberOfItemsInSectionWithNonNilVM() {
        vc.vm = self.vm
        XCTAssertEqual(vc.collectionView.numberOfItems(inSection: 0), WeatherController.WeatherViews.allCases.count)
    }
    
    @MainActor
    func testIconCache() async {
        vc.vm = self.vm
        let api = vc.api as! ImageRetrieverMock
        let cell = WeatherCell()
        guard let icon = weatherData.weather.first?.icon else { return }
        let forKey = icon as NSString

        vc.collectionView(vc.collectionView, willDisplay: cell, forItemAt: IndexPath(item: 0, section: 0))
        let expectation = XCTestExpectation(description: "Get Icon")

        Task {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(api.getIconCounter, 1)
        let cachedData = ImageCache.shared.object(forKey: forKey)
        XCTAssertNotNil(cachedData != nil)
    }

    //Tests UI defaults

}
