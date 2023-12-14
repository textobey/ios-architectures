//
//  BookItem.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/12/23.
//

import Foundation

struct BookItem: Decodable, Identifiable {
    var id: String? // isbn13
    var isbn13: String?
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
