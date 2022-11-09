//
//  ImageDataLoader.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation

protocol ImageDataLoader {
    func loadImage(from url: URL, completion: @escaping ((Result<Data?, Error>) -> Void))
}

class CachedImageDataLoader: ImageDataLoader {
    
    private let cache: NSCache<NSString, NSData>
    
    init(cache: NSCache<NSString, NSData>) {
        self.cache = cache
    }
    
    func loadImage(from url: URL, completion: @escaping ((Result<Data?, Error>) -> Void)) {
        let absoluteURLString = url.absoluteString
        let cacheKey = NSString(string: absoluteURLString)
        
        if let cachedNSData = cache.object(forKey: cacheKey) {
            let cachedData = Data(referencing: cachedNSData)
            completion(.success(cachedData))
            return
        }
        
        URLSession
            .shared
            .dataTask(with: URLRequest(url: url)) { [cache] data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(data))
                
                if let data = data {
                    cache.setObject(NSData(data: data), forKey: cacheKey)
                }
            }
            .resume()
    }
}
