//
//  BookItem.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/12/23.
//

import Foundation

struct BookItem: Decodable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
}
