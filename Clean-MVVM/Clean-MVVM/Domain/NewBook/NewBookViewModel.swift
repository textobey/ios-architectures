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
        
        let newBooks = input.fetchNewBooksTrigger
            .flatMap { [weak self] _ -> AnyPublisher<State, Never> in
                guard let self = self else {
                    return Just(State.none).eraseToAnyPublisher()
                }
                return self.fetchNewBookListChains()
            }
        
        return Output(state: Publishers.MergeMany([
            newBooks
        ]).eraseToAnyPublisher())
    }
}

extension NewBookViewModel {
    struct Input {
        let fetchNewBooksTrigger: AnyPublisher<Void, Never>
    }
    
    enum State {
        case showNewBooks([Book])
        case none
    }
    
    struct Output {
        var state: AnyPublisher<State, Never>
    }
}

extension NewBookViewModel {
    func fetchNewBookListChains() -> AnyPublisher<State, Never> {
        return bookDIContainer.fetchNewBookUseCase.execute()
            .map { booksPage -> State in
                return State.showNewBooks(booksPage.books ?? [])
            }
            .replaceError(with: State.none)
            .eraseToAnyPublisher()
    }
}
