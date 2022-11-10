//
//  Dependencies.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation

// This class is used to pass dependencies between consumers that need them.
class Dependencies {
    static var imageDataLoader: ImageDataLoader = CachedImageDataLoader(cache: .init())
    static let cart = Cart()
}
