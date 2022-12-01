//
//  Enums.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import Foundation

enum BooksURL: String {
    case new = "https://api.itbook.store/1.0/new"
    case search = "https://api.itbook.store/1.0/search/"
    case detail = "https://api.itbook.store/1.0/books/"
}

/// https://api.itbook.store/1.0/new
enum NewBookKeys: String, CodingKey {
    case total
    case books
    case error
}

/// https://api.itbook.store/1.0/search/{query(검색어)/{page}
enum SearchBookKeys: String, CodingKey {
    case error
    case total
    case page
    case books
}

/// https://api.itbook.store/1.0/books/{isbn13}
enum DetailBookKeys: String, CodingKey {
    case error
    case title
    case subtitle
    case authors
    case publisher
    case language
    case isbn10
    case isbn13
    case pages
    case year
    case rating
    case desc
    case price
    case image
    case url
    case pdf
}
