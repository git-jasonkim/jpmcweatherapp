//
//  NetworkingManagerImpl.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/7/23.
//

import Foundation

protocol NetworkingManagerImpl {
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type) async throws -> T
}
