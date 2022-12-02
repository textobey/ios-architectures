//
//  NewBookReactor.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class NewBookReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setBooks([BookItem])
    }
    
    struct State {
        var books: [BookItem] = []
    }
    
    let initialState = State()
}

extension NewBookReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return fetchBookItemsResult().flatMap { bookItems -> Observable<Mutation> in
                return Observable.just(.setBooks(bookItems))
            }
        }
    }
}

extension NewBookReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBooks(let bookItems):
            newState.books = bookItems
        }
        return newState
    }
}

private extension NewBookReactor {
    func fetchBookItemsResult() -> Observable<[BookItem]> {
        let fetchResult = NetworkService.shared.fetchBookItems()
        return Observable<[BookItem]>.create { observer in
            fetchResult.sink { result in
                switch result {
                case.success(let bookModel):
                    observer.onNext(bookModel.books ?? [])
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
