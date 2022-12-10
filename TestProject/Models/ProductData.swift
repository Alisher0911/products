//
//  Product.swift
//  TestProject
//
//  Created by Alisher Orazbay on 10.11.2022.
//

import Foundation

struct ProductData: Codable {
    let products: [Product]
    
    struct Product: Codable {
        let id: Int
        let title: String
        let description: String
        let price: Int
        let discountPercentage: Double
        let rating: Double
        let stock: Int
        let brand: String
        let category: String
        let thumbnail: String
        let images: [String]
    }
}
