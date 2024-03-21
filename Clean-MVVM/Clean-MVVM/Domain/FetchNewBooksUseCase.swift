//
//  FetchNewBooksUseCase.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import Foundation
import Combine

protocol FetchNewBooksUseCase {
    func execute() -> AnyPublisher<BooksPage, Error>
}

// TODO: Default? Impl? 무엇이 더 괜찮은 네이밍 컨벤션?
// Swift 커뮤니티에서 널리 사용되는 방식은 'Default' 접두어를 붙이는 것.
// Impl은 Java에서 널리 사용되는 네이밍 관습이고, Swift에서는 보다 명확하고 의미있는 네이밍을 지향해야한다.(Swift뿐만이 아니지 않나?)
// FetchNewBooksUseCase에 대한 구현체가 여러개 존재할 수 있고, 프로토콜에 대한 '기본' 구현임을 명확하게 전달할 수 있는 Default로 하자.

// Q. UseCase 구현체(Domain 레이어)에서 NetworkInterface(인프라스트럭처 레이어) 의존성을 가져도 되나?
// A. 헷갈렸지만 Dependency Inversion으로 Repository Interface를 같은 Domain 레이어로 두고,
// Network DataSource(혹은 인프라스트럭처)레이어와 데이터 흐름을 이뤄낸다.

final class DefaultFetchNewBooksUseCase: FetchNewBooksUseCase {
    
    private let bookRepository: BookRepository
    
    init(bookRepository: BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func execute() -> AnyPublisher<BooksPage, Error> {
        return bookRepository.fetchNewBook()
    }
}
