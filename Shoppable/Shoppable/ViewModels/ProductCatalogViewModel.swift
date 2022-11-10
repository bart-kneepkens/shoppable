//
//  ProductCatalogViewModel.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation
import Combine

class ProductCatalogViewModel {
    enum State: Equatable {
        case initial
        case loading
        case loaded([Product])
        case loadingFailed // leaving out associated value error
    }
    
    var state = CurrentValueSubject<State,Never>(.initial)
    
    private let productCatalogProvider: ProductCatalogProvider
    private let cart: Cart
    
    init(productCatalogProvider: ProductCatalogProvider, cart: Cart = Dependencies.cart) {
        self.productCatalogProvider = productCatalogProvider
        self.cart = cart
    }
    
    func loadProducts() {
        guard state.value != .loading else { return }
        
        state.value = .loading
        
        productCatalogProvider.loadCatalog { [state] result in
            switch result {
            case .success(let products):
                state.value = .loaded(products)
            case .failure:
                state.value = .loadingFailed
            }
        }
    }
    
    func createViewModel(using product: Product) -> ProductCollectionViewCellViewModel {
        .init(cart: cart, product: product)
    }
}
