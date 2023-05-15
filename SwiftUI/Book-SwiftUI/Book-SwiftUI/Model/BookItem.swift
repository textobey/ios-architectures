//
//  BookItem.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/15.
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

//extension BookItem {
//    func isBookmarked() -> Bool {
//        let list = Defaults.shared.get(for: .bookmarkList) ?? []
//        return isbn13 != nil ? list.contains(isbn13!) : false
//    }
//}
