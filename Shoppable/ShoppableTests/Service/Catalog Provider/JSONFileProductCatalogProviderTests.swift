//
//  JSONFileProductCatalogProviderTests.swift
//  ShoppableTests
//
//  Created by Bart Kneepkens on 10/11/2022.
//

import XCTest
@testable import Shoppable

final class JSONFileProductCatalogProviderTests: XCTestCase {
    
    private let localURL = Bundle.main.url(forResource: "products", withExtension: "json")!

    func testNonLocalURLPassed() {
        // Arrange
        let nonLocalURL = URL(string: "https://www.google.com")!
        let didThrowErrorExpectation = expectation(description: "Did throw the right error")
        
        // Act
        do {
            let _ = try JSONFileProductCatalogProvider(nonLocalURL)
        } catch {
            if case JSONFileProductCatalogProvider.JSONFilecatalogProviderError.nonLocalURL = error {
                didThrowErrorExpectation.fulfill()
            }
        }
        
        // Assert
        waitForExpectations(timeout: 1)
    }
    
    func testLocalURLPassed() {
        // Arrange
        
        // Act
        do {
            let _ = try JSONFileProductCatalogProvider(localURL)
        } catch {
            XCTFail()
        }
    }
}

// MARK: JSON Decoding Tests

extension JSONFileProductCatalogProviderTests {
    func testProperJSONFileDecoding() {
        // Arrange
        let provider = try? JSONFileProductCatalogProvider(localURL)
        let didDecodeFileExpectation = expectation(description: "Did decode file")
        
        // Act
        provider?.loadCatalog({ result in
            // Assert
            switch result {
            case .failure(_): XCTFail()
            case .success(let products):
                XCTAssertEqual(products.count, 14)
                didDecodeFileExpectation.fulfill()
            }
        })
        
        // Assert
        waitForExpectations(timeout: 1)
    }
    
    func testBrokenJSONFileDecoding() {
        // Arrange
        let localBrokenURL = Bundle(for: Self.self).url(forResource: "broken_products", withExtension: "json")!
        let provider = try? JSONFileProductCatalogProvider(localBrokenURL)
        
        let didThrowErrorExpectation = expectation(description: "Did throw data corrupted error")
        
        // Act
        provider?.loadCatalog({ result in
            switch result {
            case .failure(let error):
                switch error {
                case DecodingError.dataCorrupted(_):
                    didThrowErrorExpectation.fulfill()
                default:
                    XCTFail("Threw an error but the wrong one")
                }
            case .success(_): XCTFail()
            }
        })
        
        // Assert
        waitForExpectations(timeout: 1)
    }
}
