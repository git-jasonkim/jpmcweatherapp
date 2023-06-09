//
//  ImageRetrieverMock.swift
//  JPMCWeatherAppTests
//
//  Created by Jason Kim on 6/8/23.
//

import XCTest
@testable import JPMCWeatherApp

final class ImageRetrieverMock: ImageRetrieverImpl {
        var getIconCounter = 0
    
    func fetch(_ code: String) async throws -> Data {
        getIconCounter += 1
        if let data = UIImage(systemName: "sun.min")?.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            throw ImageRetriever.RetrieverError.invalidData
        }
    }
}


