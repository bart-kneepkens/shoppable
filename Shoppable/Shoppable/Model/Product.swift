//
//  Product.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation

struct Product: Decodable {
    enum `Type`: String, Decodable {
        case couch
        case chair
    }
    
    struct Price: Decodable {
        enum Currency: String, Decodable {
            case kr
        }
        
        let value: Double
        let currency: Currency
    }
    
    struct Info: Decodable {
        let color: String
        let material: String?
        let numberOfSeats: Int?
    }

    let id: String
    let name: String
    let type: `Type`
    let price: Price
    let imageUrl: String
    let info: Info
}
