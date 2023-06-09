//
//  Endpoint.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/7/23.
//

import Foundation
import CoreLocation

enum Endpoint {
    case getWeatherByCity(name: String)
    case getWeatherByZip(code: String)
    case getWeatherByCoordinate(coordinate: CLLocationCoordinate2D)
    case getWeatherIcon(code: String)
}

extension Endpoint {
    enum MethodType {
        case GET
    }
}

extension Endpoint {
    
    var apiHost: String { "api.openweathermap.org" }
    var iconHost: String { "openweathermap.org" }
    var apiKey: String { "6e487985bbe638d58f52dda0f8f40280" } //TODO: use a secret manager to offload secrets
    
    var host: String {
        switch self {
        case .getWeatherByCity, .getWeatherByZip, .getWeatherByCoordinate:
            return apiHost
        case .getWeatherIcon:
            return iconHost
        }
    }
    
    var version: String {
        switch self {
        default:
            return "2.5"
        }
    }
    
    var path: String {
        switch self {
        case .getWeatherByCity, .getWeatherByZip, .getWeatherByCoordinate:
            return "/data/\(version)/weather"
        case .getWeatherIcon(let code):
            return "/img/wn/\(code)@2x.png"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .getWeatherByCity, .getWeatherByZip, .getWeatherByCoordinate, .getWeatherIcon:
            return .GET
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .getWeatherByCity(let name):
            return ["q": name]
        case .getWeatherByZip(let code):
            return ["zip": code]
        case .getWeatherByCoordinate(let coordinate):
            return ["lat": coordinate.latitude.description, "lon": coordinate.longitude.description]
        default:
            return nil
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        requestQueryItems.append(URLQueryItem(name: "appid", value: apiKey))
        requestQueryItems.append(URLQueryItem(name: "units", value: "imperial"))

        if let queryItems = queryItems {
            queryItems.forEach { item in
                requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
            }
            urlComponents.queryItems = requestQueryItems
        }
        
        return urlComponents.url
    }
}
