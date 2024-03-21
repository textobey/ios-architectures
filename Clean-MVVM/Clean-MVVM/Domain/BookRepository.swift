//
//  BookRepository.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/18/24.
//

import Combine

protocol BookRepository {
    func fetchNewBook() -> AnyPublisher<BooksPage, Error>
}
