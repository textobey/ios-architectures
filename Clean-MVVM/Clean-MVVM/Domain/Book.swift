//
//  Book.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import Foundation

struct BooksPage: Decodable {
    var total: String?
    var page: String?
    var books: [Book]?
    var error: String?
    var title: String?
    var subtitle: String?
    var authors: String?
    var publisher: String?
    var language: String?
    var isbn10: String?
    var isbn13: String?
    var pages: String?
    var year: String?
    var rating: String?
    var desc: String?
    var price: String?
    var image: String?
    var url: String?
    var pdf: [String: String]?
}

struct Book: Decodable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
}
