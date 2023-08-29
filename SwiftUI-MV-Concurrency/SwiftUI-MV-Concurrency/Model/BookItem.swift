//
//  BookItem.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import Foundation

struct BookItem: Decodable, Identifiable {
    var id: String?
    var title: String?
    var subtitle: String?
    var price: String?
    var image: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "isbn13"
        case title
        case subtitle
        case price
        case image
        case url
    }
}
