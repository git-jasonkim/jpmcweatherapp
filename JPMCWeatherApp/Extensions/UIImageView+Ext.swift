//
//  UIImageView+Ext.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

extension UIImageView {
    
    @MainActor
    func loadIcon(code: String, api: ImageRetrieverImpl = ImageRetriever(), cache: ImageCache = ImageCache.shared) async {
        let forKey = code as NSString
        if let imageData = cache.object(forKey: forKey) {
            self.image = UIImage(data: imageData)
            return
        }
        
        do {
            let data = try await api.fetch(code)
            cache.set(object: data as NSData, forKey: forKey)
            self.image = UIImage(data: data)
        } catch {
            #if DEBUG
            print(error)
            #endif
            self.image = UIImage(systemName: "xmark")
        }
    }
    
}
