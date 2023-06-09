//
//  ImageRetriever.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation

protocol ImageRetrieverImpl {
    func fetch(_ code: String) async throws -> Data
}

struct ImageRetriever: ImageRetrieverImpl {
    func fetch(_ code: String) async throws -> Data {
        guard let url = Endpoint.getWeatherIcon(code: code).url else {
            throw RetrieverError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

extension ImageRetriever {
    enum RetrieverError: Error {
        case invalidUrl
        case invalidData
    }
}
