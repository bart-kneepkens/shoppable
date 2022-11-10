//
//  ProductCollectionViewCellViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 09/11/2022.
//

import Foundation
import Combine

class ProductCollectionViewCellViewModel {
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
    
    private let cart: Cart
    private let product: Product
    private var cancellable: AnyCancellable?
    
    init(cart: Cart, product: Product, imageDataLoader: ImageDataLoader = Dependencies.imageDataLoader) {
        self.cart = cart
        self.product = product
        
        if let imageURL = URL(string: product.imageUrl) {
            cancellable = imageDataLoader
                .loadImage(from: imageURL)
                .subscribe(productImageData)
        }
    }
    
    func addToCart() {
        cart.products.value.append(product)
    }
}
