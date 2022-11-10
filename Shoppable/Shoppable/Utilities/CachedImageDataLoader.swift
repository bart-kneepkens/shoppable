//
//  CachedImageDataLoader.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation
import Combine

class CachedImageDataLoader: ImageDataLoader {
    
    private let networkSession: NetworkSession
    private let cache: NSCache<NSString, NSData>
    
    init(cache: NSCache<NSString, NSData>, networkSession: NetworkSession = URLSession.shared) {
        self.cache = cache
        self.networkSession = networkSession
    }
    
    /// A published that will either: - return the data for a URL if it is available in cache, or - fetch the data from the URL and return it.
    /// Whenever a fetch occurs, the data is added to the cache.
    /// Publisher is always received on the main dispatchQueue
    func loadImage(from url: URL) -> AnyPublisher<Data?, Never> {
        let absoluteURLString = url.absoluteString
        let cacheKey = NSString(string: absoluteURLString)
        
        if let cachedNSData = cache.object(forKey: cacheKey) {
            let cachedData = Data(referencing: cachedNSData)
            return Just(cachedData).eraseToAnyPublisher()
        }
        
        return networkSession
            .dataTaskPublisher(using: url)
            .handleEvents(receiveOutput: { [cache] data in
                if let data = data {
                    cache.setObject(NSData(data: data), forKey: cacheKey)
                }
            })
            .catch { error in
                return Just(nil)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
