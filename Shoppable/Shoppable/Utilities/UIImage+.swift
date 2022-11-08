//
//  UIImage+.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import UIKit

extension UIImage {
    static func loadFromURL(_ url: URL, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
