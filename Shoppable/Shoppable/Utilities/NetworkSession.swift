//
//  NetworkSession.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation
import Combine

protocol NetworkSession {
    func dataTaskPublisher(using url: URL) -> AnyPublisher<Data?, URLError>
}

extension URLSession: NetworkSession {
    func dataTaskPublisher(using url: URL) -> AnyPublisher<Data?, URLError> {
        dataTaskPublisher(for: url)
            .map { data, _ in
                data
            }
            .eraseToAnyPublisher()
    }
}
