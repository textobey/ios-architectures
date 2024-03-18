//
//  BookRepository.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/18/24.
//

import Combine

protocol BookRepository {
    @discardableResult
    func fetchNewBooks(
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) -> Cancellable?
}
