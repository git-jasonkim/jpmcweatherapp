//
//  ImageCache.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import Foundation

final class ImageCache {
    
    typealias CacheType = NSCache<NSString, NSData>
    
    static let shared = ImageCache()
    
    private init() {}
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50 MB
        return cache
    }()
    
    func object(forKey key: NSString) -> Data? {
        return cache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
