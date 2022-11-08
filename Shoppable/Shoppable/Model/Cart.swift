//
//  Cart.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation
import Combine

class Cart {
    var products = CurrentValueSubject<[Product], Never>([])
    
    var totalKronar: Double {
        products.value.map({ $0.price.value }).reduce(0, +)
    }
}
