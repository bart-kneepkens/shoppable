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
    private let imageLoader: ImageDataLoader = DefaultImageDataLoader()
    
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
    
    func loadProductImage(for product: Product, completion: @escaping ((Result<Data?, Error>) -> Void)) {
        if let imageURL = URL(string: product.imageUrl) {
            try? imageLoader.loadImage(from: imageURL) { result in
                completion(result)
            }
        }
    }
}
