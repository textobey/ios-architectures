//
//  SearchBookReactor.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class SearchBookReactor: Reactor {
    
    fileprivate var refreshTrigger = PublishRelay<Void>()
    fileprivate var page: Int = 1
    
    enum Action {
        case phraseSearch(String)
        case paging(String)
    }
    
    enum Mutation {
        case setBooks([BookItem])
        case appendBooks([BookItem])
    }
    
    struct State {
        var books: [BookItem] = []
    }
    
    let initialState = State()
    
    init() {
        self.refresh()
    }
}

extension SearchBookReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .phraseSearch(let word):
            self.page = 1
            return fetchBookItemsResult(of: word).flatMap { bookItems -> Observable<Mutation> in
                return Observable.just(.setBooks(bookItems))
            }
        case .paging(let word):
            // - TODO: !isRefreshing
            self.page += 1
            return fetchBookItemsResult(of: word, page: self.page).flatMap { bookItems -> Observable<Mutation> in
                return Observable.just(.appendBooks(bookItems))
            }
        }
    }
}

extension SearchBookReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBooks(let bookItems):
            newState.books = bookItems
        case .appendBooks(let bookItems):
            newState.books.append(contentsOf: bookItems)
        }
        return newState
    }
}

extension SearchBookReactor {
    func fetchBookItemsResult(of word: String, page: Int = 1) -> Observable<[BookItem]> {
        let fetchResult = NetworkService.shared.fetchSearchResults(of: word, page: page)
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
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, refreshTrigger.map { Action.phraseSearch("Apple") })
    }
}

extension SearchBookReactor {
    func refresh(delay: DispatchTime = DispatchTime.now() + 3) {
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            print("transform(_: 을 이용한 Mutate")
            self.refreshTrigger.accept(())
        })
    }
}
