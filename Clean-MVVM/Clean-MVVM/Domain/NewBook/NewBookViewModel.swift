//
//  NewBookViewModel.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import Foundation
import Combine

class NewBookViewModel: ViewModelType {
    private let bookDIContainer: BookDIContainer
    
    init(bookDIContainer: BookDIContainer) {
        self.bookDIContainer = bookDIContainer
    }
    
    func transform(input: Input) -> Output {
        return input.flatMap { [weak self] event -> Output in
            guard let self = self else {
                return Just(State.none).eraseToAnyPublisher()
            }
            return self.transform(event: event)
        }
        .eraseToAnyPublisher()
    }
}

extension NewBookViewModel {
    // View events
    enum ActionType {
        case fetchNewBooks
    }
    
    // Wrapped Output
    enum State {
        case newBooks([Book])
        case none
    }
    
    private func transform(event: ActionType) -> Output {
        switch event {
        case .fetchNewBooks:
            return self.fetchNewBookList()
        }
    }
}

// MARK: - Private view event methods

extension NewBookViewModel {
    func fetchNewBookList() -> Output {
        return bookDIContainer.fetchNewBookUseCase.execute()
            .map { booksPage -> State in
                return State.newBooks(booksPage.books ?? [])
            }
            .replaceError(with: State.none)
            .eraseToAnyPublisher()
    }
}
