//
//  CartViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation
import Combine

class CartViewModel {
    private let cart: Cart
    
    init(cart: Cart) {
        self.cart = cart
    }
    
    lazy var products = cart.products
    
    lazy var totalKronar = cart.products.map { products in
        products.map({ $0.price.value }).reduce(0, +)
    }
    
    func removeProduct(atIndex index: IndexPath.Index) {
        cart.products.value.remove(at: index)
    }
}
