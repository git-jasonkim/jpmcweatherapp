//
//  GeolocationService.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation
import CoreLocation

protocol GeolocationServiceDelegate: AnyObject {
    func didUpdateLocation(coordinate: CLLocationCoordinate2D?, error: Error?)
}

class GeolocationService: NSObject, CLLocationManagerDelegate {
    
    public weak var delegate: GeolocationServiceDelegate?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchLocation() {
        locationManager.delegate = self
        if (locationManager.authorizationStatus != .authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let location = locations[0]
        self.delegate?.didUpdateLocation(coordinate: location.coordinate, error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.didUpdateLocation(coordinate: nil, error: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
