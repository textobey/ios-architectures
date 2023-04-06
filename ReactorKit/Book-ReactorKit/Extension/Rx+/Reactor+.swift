//
//  Reactor+.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/18.
//

import ReactorKit
import RxSwift
import RxCocoa

extension Reactor {
    
//    var makeEmpty: Observable<Mutation> {
//        return .empty()
//    }
//
//    func convertEmpty(_ observables: [Observable<Any>]) -> Observable<Mutation> {
//        return Observable.concat(observables.compactMap { _ in Observable<Mutation>.empty() })
//    }
//
//    func concat(_ mutations: [Mutation], with observable: Observable<[String]> = .empty()) -> Observable<Mutation> {
//        Observable.concat(mutations.map { Observable.just($0) }).concat(observable.flatMap { _ in Observable<Mutation>.empty() })
//    }
//    
//    func merge(_ mutations: [Mutation], with mutationObservable: Observable<Mutation> = .empty()) -> Observable<Mutation> {
//        var observables: [Observable<Mutation>] = mutations.map { Observable.just($0) }
//        observables.append(mutationObservable)
//        return .merge(observables)
//    }
    
//    private func backward(_ s1: Any, _ s2: Any) -> Bool? {
//        let _s1 = s1 as? Mutation
//        let _s2 = s2 as? Mutation
//
//        if _s1 == nil && _s2 == nil {
//            return nil
//        } else if _s1 != nil && _s2 != nil {
//            return nil
//        } else if _s1 == nil && _s2 != nil {
//            return _s1 < _s2
//        } else if _s1 != nil && _s2 == nil {
//            return _s1 > _s2
//        }
//    }
//
//    private func sortObservables(_ observables: [Observable<Any>] = [.empty()]) -> Observable<Mutation> {
//        observables.sorted(by: { ob1, ob2 in
//            let _ob1 = ob1 as? Mutation
//            let _ob2 = ob2 as? Mutation
//
//            o
//
//            if _ob1 == nil && _ob2 == nil {
//
//            } else if _ob1 != nil && _ob2 != nil {
//
//            } else if _ob1 == nil && _ob2 != nil {
//                return ob1 < ob2
//            } else if _ob1 != nil && _ob2 == nil {
//                return ob1 > ob2
//            }
//        })
//    }
}
