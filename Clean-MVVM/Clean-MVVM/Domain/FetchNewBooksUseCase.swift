//
//  FetchNewBooksUseCase.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import Foundation
import Combine

protocol FetchNewBooksUseCase {
    func execute(
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) -> Cancellable?
}

// TODO: Default? Impl? 무엇이 더 괜찮은 네이밍 컨벤션?

// Q. UseCase 구현체(Domain 레이어)에서 NetworkInterface(인프라스트럭처 레이어) 의존성을 가져도 되나?
// A. 헷갈렸지만 Dependency Inversion으로 Repository Interface를 같은 Domain 레이어로 두고,
// Network DataSource(혹은 인프라스트럭처)레이어와 데이터 흐름을 이뤄낸다.

final class FetchNewBooksUseCaseImpl: FetchNewBooksUseCase {
    
    private let bookRepository: BookRepository
    
    init(bookRepository: BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func execute(
        completion: @escaping (Result<BooksPage, Error>) -> Void
    ) -> Cancellable? {
        return bookRepository.fetchNewBooks(completion: { result in
            completion(result)
        })
    }
}
