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
        var state: Bool = false
    }
    
    let initialState = State()
}

extension NewBookReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .empty()
//            NetworkService.shared.fetchBookItems { result in
//                switch result {
//                case .success(let bookItems):
//                    return Observable.just(.setBooks(bookItems))
//                case .failure:
//                    return .empty
//                }
//            }
        }
    }
}

extension NewBookReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setBooks(let bookItems):
            return state
        }
    }
}
