//
//  ProductsViewModel.swift
//  TestProject
//
//  Created by Alisher Orazbay on 10.11.2022.
//

import Foundation

final class ProductsViewModel {
    
    var products: ObservableObject<ProductData?> = ObservableObject(nil)
    
    func getProducts() {
        NetworkService.shared.request("https://dummyjson.com/products") { [weak self] (result: Result<ProductData, Error>) in
            
            switch result {
            case.success(let response):
                self?.products.value = response
            case .failure(let error):
                print(error)
            }
        }

    }
}
