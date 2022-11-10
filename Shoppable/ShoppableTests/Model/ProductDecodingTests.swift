//
//  ProductDecodingTests.swift
//  ShoppableTests
//
//  Created by Bart Kneepkens on 10/11/2022.
//

import XCTest
@testable import Shoppable

final class ProductDecodingTests: XCTestCase {

    // MARK: - Price and enum safety
    func testPriceCurrencyKronar() {
        // Arrange
       let properCurrencyJSONData = """
        {
            "value": 4495,
            "currency": "kr"
        }
        """.data(using: .utf8)!
        
        // Act
        let decodedValue = try! JSONDecoder().decode(Product.Price.self, from: properCurrencyJSONData)
        
        // Assert
        XCTAssertEqual(decodedValue.value, 4495)
        XCTAssertEqual(decodedValue.currency, .kronar)
    }
    
    // This test covers the case where we might receive a value that was previously unknown to the client.
    // Because we use an enum for the model, this can lead to the decoder failing.
    func testPriceCurrencyUnknown() {
        // Arrange
       let properCurrencyJSONData = """
        {
            "value": 4495,
            "currency": "eurodollars"
        }
        """.data(using: .utf8)!
        
        // Act
        let decodedValue = try! JSONDecoder().decode(Product.Price.self, from: properCurrencyJSONData)
        
        // Assert
        XCTAssertEqual(decodedValue.value, 4495)
        XCTAssertEqual(decodedValue.currency, .unknown("eurodollars"))
    }

}
