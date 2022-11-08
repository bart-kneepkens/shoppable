//
//  ProductCatalogProvider.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation

protocol ProductCatalogProvider {
    func loadCatalog(_ completion: @escaping ((Result<[Product], Error>) -> Void))
}
