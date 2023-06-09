//
//  MainControllerViewModel.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation
import CoreLocation

class MainControllerViewModel {
    
    internal let api: WeatherAPIImpl

    init(api: WeatherAPIImpl = WeatherAPI()) {
        self.api = api
    }

    ///A callback method to notify MainController to update views each time state is updated
    ///
    ///This method is defined in MainController setupVM() method
    public var handleState: ((MainControllerViewModel.State) -> ())?
    
    private(set) var state: MainControllerViewModel.State = .initial {
        didSet {
            handleState?(state)
        }
    }
    
    @MainActor
    func searchWeather(for location: String) async {
        
        let izZip = {
            if let _ = Int(location) {
                return true
            } else {
                return false
            }
        }() //TODO: use regex for valid zip codes
        
        state = .loading
        let result = await api.getWeather(for: location, isZip: izZip)
        switch result {
        case .failure(let error):
            state = .failure(error: error.localizedDescription)
        case .success(let weatherData):
            //UserDefaults used to save last searched location
            UserDefaults.standard.set(weatherData.name, forKey: UserDefaults.Key.lastSearchedLocation)
            state = .success(data: weatherData)
        }
    }
    
    @MainActor
    func searchWeather(for coordinate: CLLocationCoordinate2D) async {
        state = .loading
        let result = await api.getWeather(for: coordinate)
        switch result {
        case .failure(let error):
            state = .failure(error: error.localizedDescription)
        case .success(let weatherData):
            //UserDefaults used to save last searched location
            UserDefaults.standard.set(weatherData.name, forKey: UserDefaults.Key.lastSearchedLocation)
            state = .success(data: weatherData)
        }
    }
}

extension MainControllerViewModel {
    enum State {
        case initial
        case loading
        case success(data: WeatherModel)
        case failure(error: String)
    }
}
