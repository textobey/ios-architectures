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
    fileprivate var allBooks: [[BookItem]] = []
    
    enum Action {
        case refresh
        case paging
    }
    
    enum Mutation {
        case setBooks([BookItem])
        case pagingBooks
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
        case .paging:
            guard allBooks.count > 0 else { return .empty() }
            return Observable.just(.pagingBooks)
        }
    }
}

extension NewBookReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBooks(let bookItems):
            let slicedBookImtes = sliceBookItems(bookItems)
            allBooks = slicedBookImtes
            newState.books = slicedBookImtes.first ?? []
            allBooks.removeFirst()
            print("남은 책 목록", allBooks.count)
        case .pagingBooks:
            if let nextBooks = allBooks.first {
                newState.books.append(contentsOf: nextBooks)
                allBooks.removeFirst()
                print("남은 책 목록", allBooks.count)
            } else {
                print("마지막 페이지 입니다.")
            }
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
    
    private func sliceBookItems(_ bookItems: [BookItem]) -> [[BookItem]] {
        var slicedBookItems: [[BookItem]] = [[BookItem]]()
        for i in stride(from: 0, to: bookItems.count, by: 3) {
            if let split = bookItems[safe: i ..< i + 3] {
                slicedBookItems.append(Array(split))
            }
        }
        return slicedBookItems
    }
}
