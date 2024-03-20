//
//  BookAPIEndPoint.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/19/24.
//

import Foundation

struct BookAPIEndPoint {
    static func fetchBooks() -> EndPoint<BooksPage> {
        return EndPoint(
            path: "/1.0/new",
            method: .get
        )
    }
}
