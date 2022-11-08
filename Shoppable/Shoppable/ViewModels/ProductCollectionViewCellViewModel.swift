//
//  ProductCollectionViewCellViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation

class ProductCollectionViewCellViewModel {
    private let cart: Cart
    
    init(cart: Cart) {
        self.cart = cart
    }
    
    func addToCart(_ product: Product) {
        cart.products.value.append(product)
    }
}
