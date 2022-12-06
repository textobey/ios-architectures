//
//  BookDetailReactor.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/05.
//

import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class BookDetailReactor: Reactor {
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setBookDetail(BookModel)
    }
    
    struct State {
        let isbn13: String
        var bookModel: BookModel?
    }
    
    let initialState: State
    
    init(isbn13: String) {
        initialState = State(isbn13: isbn13)
    }
}

extension BookDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return fetchBookItemsResult().flatMap { bookModel -> Observable<Mutation> in
                return Observable.just(.setBookDetail(bookModel))
            }
        }
    }
}

extension BookDetailReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBookDetail(let bookModel):
            newState.bookModel = bookModel
        }
        return newState
    }
}

private extension BookDetailReactor {
    private func fetchBookItemsResult() -> Observable<BookModel> {
        let fetchResult = NetworkService.shared.fetchBookDetail(of: initialState.isbn13)
        return Observable<BookModel>.create { observer in
            fetchResult.sink { result in
                switch result {
                case .success(let bookModel):
                    observer.onNext(bookModel)
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
