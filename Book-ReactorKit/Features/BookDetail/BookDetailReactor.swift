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
    
    let initialState: State
    
    init(isbn13: String) {
        initialState = State(isbn13: isbn13)
    }
}

extension BookDetailReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(.setBookmarkState),
                fetchBookItemsResult().flatMap { bookModel -> Observable<Mutation> in
                    return Observable.just(.setBookDetail(bookModel))
                }
            ])
        case .bookmark:
            self.updateBookmarkList(isbn13: currentState.isbn13)
            return Observable.just(.changeBookmarkState)
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
    
    private func updateBookmarkList(isbn13: String) {
        let isBookmarked = checkBookIsBookmarked(isbn13: isbn13)
        if isBookmarked {
            Defaults.shared.removeBookmark(isbn13: currentState.isbn13)
        } else {
            Defaults.shared.appendBookmark(isbn13: currentState.isbn13)
        }
        InternalNotificationCenter.updatedBookmarkList.post()
    }
}
