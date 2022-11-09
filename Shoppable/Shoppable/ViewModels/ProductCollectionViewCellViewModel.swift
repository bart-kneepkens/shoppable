//
//  ProductCollectionViewCellViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation
import Combine

class ProductCollectionViewCellViewModel {
    private let cart: Cart
    private let product: Product
    let imageLoader: ImageDataLoader = DefaultImageDataLoader()
    
    var productName: String {
        product.name
    }
    
    var productDescription: String {
        var description: String = "\(product.info.color)"
        
        switch product.type {
        case .couch:
            if let numberOfSeats = product.info.numberOfSeats {
                description.append(" - \(numberOfSeats) seats")
            }
        case .chair:
            if let material = product.info.material {
                description.append(" - \(material)")
            }
        }
        
        return description
    }
    
    var productImageData = CurrentValueSubject<Data?, Never>(nil)
    
    init(cart: Cart, product: Product) {
        self.cart = cart
        self.product = product
        
        if let imageURL = URL(string: product.imageUrl) {
            // LOAD
            try? imageLoader.loadImage(from: imageURL) { [productImageData] result in
                if case .success(let imageData) = result {
                    productImageData.value = imageData
                }
            }
        }
    }
    
    func addToCart() {
        cart.products.value.append(product)
    }
}
