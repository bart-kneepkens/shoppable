//
//  JSONFileProductCatalogProvider.swift
//  Shoppable
//
//  Created by Bart Kneepkens on 08/11/2022.
//

import Foundation

private struct ProductFile: Decodable {
    let products: [Product]
}

class JSONFileProductCatalogProvider: ProductCatalogProvider {
    private let url: URL
    
    init(_ url: URL) throws {
        guard url.isFileURL else { throw JSONFilecatalogProviderError.nonLocalURL }
        self.url = url
    }
    
    func loadCatalog(_ completion: @escaping ((Result<[Product], Error>) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [url] in
            do {
                let jsonFileData = try Data(contentsOf: url)
                let file = try JSONDecoder().decode(ProductFile.self, from: jsonFileData)
                
                completion(.success(file.products))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension JSONFileProductCatalogProvider {
    enum JSONFilecatalogProviderError: Error {
        case nonLocalURL
    }
}
