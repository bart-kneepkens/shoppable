//
//  CartViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation
import Combine

class CartViewModel {
    lazy var products = cart.products
    
    lazy var totalKronar = cart.products.map { products in
        products.map({ $0.price.value }).reduce(0, +)
    }
    
    private let cart: Cart
    private let imageDataLoader: ImageDataLoader
    
    init(cart: Cart = Dependencies.cart, imageLoader: ImageDataLoader = Dependencies.imageDataLoader) {
        self.cart = cart
        self.imageDataLoader = imageLoader
    }
    
    func removeProduct(atIndex index: IndexPath.Index) {
        cart.products.value.remove(at: index)
    }
    
    func loadProductImage(for product: Product) -> AnyPublisher<Data?, Never> {
        if let imageURL = URL(string: product.imageUrl) {
            return imageDataLoader
                .loadImage(from: imageURL)
        }
        return Just(nil).eraseToAnyPublisher()
    }
}
