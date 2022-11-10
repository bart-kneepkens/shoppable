//
//  CachedImageDataLoaderTests.swift
//  ShoppableTests
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import XCTest
import Combine
@testable import Shoppable

final class CachedImageDataLoaderTests: XCTestCase {
    
    private let fakeURL = URL(string: "https://www.google.com")!
    private let fakeData = "test_data".data(using: .utf8)!
    private let fakeRemoteData = "this_fake_data_is_returned_by_URLSession".data(using: .utf8)!
    private var cancellables = Set<AnyCancellable>()

    func testCachedImageIsReturned() {
        // Arrange
        let testCache: NSCache<NSString, NSData> = .init()
        let imageDataLoader = CachedImageDataLoader(cache: testCache)
        
        testCache.setObject(NSData(data: fakeData), forKey: NSString(string: fakeURL.absoluteString))
        
        let didReturnCachedImageExpectation = expectation(description: "did return cached image")
        
        // Act
        let _ = imageDataLoader
            .loadImage(from: fakeURL)
            .sink { data in
                if data == self.fakeData {
                    didReturnCachedImageExpectation.fulfill()
                }
            }
        
        // Assert
        waitForExpectations(timeout: 1)
    }
    
    func testURLSessionCallIsDoneWhenNoCachedVersionAvailable() {
        // Arrange
        let testCache: NSCache<NSString, NSData> = .init()
        
        let networkSessionMock = NetworkSessionMock([fakeURL: fakeRemoteData])
        
        let imageDataLoader = CachedImageDataLoader(cache: testCache, networkSession: networkSessionMock)
        
        let didReturnDataFromNetworkSessionExpectation = expectation(description: "did return image data from URL")
        let didCacheDataExpectation = expectation(description: "did cache returned image data")
        
        // Act
        imageDataLoader
            .loadImage(from: fakeURL)
            .sink { data in
                if data == self.fakeRemoteData {
                    didReturnDataFromNetworkSessionExpectation.fulfill()
                }
                
                if testCache.object(forKey: NSString(string: self.fakeURL.absoluteString)) == NSData(data: self.fakeRemoteData) {
                    didCacheDataExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Assert
        waitForExpectations(timeout: 5)
    }
}
