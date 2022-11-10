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
        enum Currency: Decodable, Equatable {
            case kronar
            case unknown(String)
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let stringValue = try container.decode(String.self)
                
                switch stringValue {
                case "kr":
                    self = .kronar
                default:
                    self = .unknown(stringValue)
                }
            }
            
            var shortDescription: String {
                switch self {
                case .kronar: return "kr"
                case .unknown(let unknownValue):
                    return unknownValue
                }
            }
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

// MARK: - Product + Hashable

extension Product: Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
