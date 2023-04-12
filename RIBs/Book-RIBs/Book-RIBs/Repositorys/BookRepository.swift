//
//  BookRepository.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation

protocol BookRepository: AnyObject {
    func fetchBookItems() -> ReturnResult<BookModel, Error>
    func fetchBookDetail(of isbn13: String) -> ReturnResult<BookModel, Error>
    func fetchSearchResults(of word: String, page: Int) -> ReturnResult<BookModel, Error>
}
