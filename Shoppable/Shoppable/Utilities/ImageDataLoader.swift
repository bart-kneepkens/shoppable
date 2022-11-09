//
//  ImageDataLoader.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation

protocol ImageDataLoader {
    func loadImage(from url: URL, completion: @escaping ((Result<Data?, Error>) -> Void)) throws
}

class DefaultImageDataLoader: ImageDataLoader {
    func loadImage(from url: URL, completion: @escaping ((Result<Data?, Error>) -> Void)) throws {
        URLSession
            .shared
            .dataTask(with: URLRequest(url: url)) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(data))
        }
        .resume()
    }
}
