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
import Foundation

class BookDetailReactor: Reactor {
    
    enum Action {
        case refresh
        case bookmark
    }
    
    enum Mutation {
        case setBookDetail(BookModel)
        case setBookmarkState
        case changeBookmarkState
    }
    
    struct State {
        let isbn13: String
        var bookModel: BookModel?
        var isBookmarked: Bool = false
    }
    
    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType, isbn13: String) {
        self.provider = provider
        initialState = State(isbn13: isbn13)
    }
    
    //deinit {
    //    print("BookDetailReactor Deinit")
    //}
}

extension BookDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(.setBookmarkState),
                fetchBookItemsResult().map(Mutation.setBookDetail)
            ])
        case .bookmark:
            let isBookmarked = checkBookIsBookmarked(isbn13: currentState.isbn13)
            let storageResultObservable = isBookmarked
            ? self.provider.storageService.delete(isbn13: currentState.isbn13)
            : self.provider.storageService.insert(isbn13: currentState.isbn13)
            
            return Observable.concat([
                storageResultObservable.flatMap { _ in Observable<Mutation>.empty() },
                self.provider.internalNotificationService.notify(event: .updateBookmarkList).map { _ in Mutation.changeBookmarkState } // map(Mutation.changeBookmarkState)
            ])
        }
    }
}

extension BookDetailReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBookmarkState:
            newState.isBookmarked = checkBookIsBookmarked(isbn13: currentState.isbn13)
        case .setBookDetail(let bookModel):
            newState.bookModel = bookModel
        case .changeBookmarkState:
            newState.isBookmarked = !newState.isBookmarked
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
    
    private func checkBookIsBookmarked(isbn13: String) -> Bool {
        return Defaults.shared.get(for: .bookmarkList)?.contains(isbn13) ?? false
    }
}
