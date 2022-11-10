//
//  NetworkSessionMock.swift
//  ShoppableTests
//
//  Created by Bart Kneepkens on 10/11/2022.
//

import Foundation
import Combine

@testable import Shoppable

final class NetworkSessionMock: NetworkSession {
    let mockData: [URL: Data]
    
    init(_ mockData: [URL:Data]) {
        self.mockData = mockData
    }
    
    func dataTaskPublisher(using url: URL) -> AnyPublisher<Data?, URLError> {
        if let data = mockData[url] {
            return Just(data).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        return Just(nil).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
}
