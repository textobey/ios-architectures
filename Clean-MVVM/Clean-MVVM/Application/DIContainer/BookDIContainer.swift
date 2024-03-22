//
//  BookDIContainer.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/22/24.
//

import Foundation

final class BookDIContainer {
    
    private let coreDIContainer: CoreDIContainer
    
    init(coreDIContainer: CoreDIContainer) {
        self.coreDIContainer = coreDIContainer
    }
    
    lazy var bookRepository: BookRepository = {
        let defaultBookRepository = DefaultBookRepository(
            dataTransferSerivce: coreDIContainer.dataTransferService
        )
        return defaultBookRepository
    }()
    
    lazy var fetchNewBookUseCase: FetchNewBooksUseCase = {
        let defaultFetchNewBooksUseCase = DefaultFetchNewBooksUseCase(
            bookRepository: bookRepository
        )
        return defaultFetchNewBooksUseCase
    }()
    
}
