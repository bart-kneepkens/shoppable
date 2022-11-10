//
//  ImageDataLoader.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation
import Combine

protocol ImageDataLoader {
    func loadImage(from url: URL) -> AnyPublisher<Data?, Never>
}
