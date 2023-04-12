//
//  BookRepositoryImpl.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/12.
//

import Foundation

final class BookRepositoryImpl: BookRepository {
    
    private let network: Network
    
    public init(network: Network) {
        self.network = network
    }
    
    func fetchBookItems() -> ReturnResult<BookModel, Error> {
        return network.request(.new)
    }
    
    func fetchBookDetail(of isbn13: String) -> ReturnResult<BookModel, Error> {
        return network.request(.detail(isbn13: isbn13))
    }
    
    func fetchSearchResults(of word: String, page: Int = 1) -> ReturnResult<BookModel, Error> {
        return network.request(.search(word: word, page: page))
    }
}
