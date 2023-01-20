//
//  UserDefaultsService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/16.
//

import Foundation
import RxSwift
import RxRelay

enum StorageEvent {
    case create
    case save
    case insert([String])
    case delete([String])
    case reset
}

extension DefaultsKey {
    static let bookmarkList = Key<[String]>("bookmark_list")
}

struct StorageEventDispatcher {
    fileprivate let event = PublishSubject<StorageEvent>()
}

protocol StorageServiceType {
    var eventDispatcher: StorageEventDispatcher { get }
    func fetchBookmark() -> Observable<[String]>

    @discardableResult
    func reset() -> Observable<Void>
    @discardableResult
    func save(_ isbn13s: [String]) -> Observable<Void>
    
    func insert(isbn13: String) -> Observable<[String]>
    func delete(isbn13: String) -> Observable<[String]>
    func isBookmarked(isbn13: String) -> Observable<Bool>
}

final class StorageService: BaseService, StorageServiceType {

    private var shared: Defaults {
        return Defaults.shared
    }

    func fetchBookmark() -> Observable<[String]> {
        if let savedStorage = self.shared.get(for: .bookmarkList) {
            return .just(savedStorage)
        }
        return .just([])
    }

    let eventDispatcher: StorageEventDispatcher = StorageEventDispatcher()

    func reset() -> Observable<Void> {
        shared.clear(.bookmarkList)
        return Observable.just(())
    }
    
    func save(_ bookmarks: [String]) -> Observable<Void> {
        self.shared.set(bookmarks, for: .bookmarkList)
        self.eventDispatcher.event.onNext(.save)
        return Observable.just(())
    }

    func insert(isbn13: String) -> Observable<[String]> {
        return fetchBookmark()
            .flatMap { [weak self] list -> Observable<[String]> in
                guard let `self` = self else { return .empty() }
                let newList = list.contains(isbn13) ? list : list + [isbn13]
                return self.save(newList).map { newList }
            }
            .do(onNext: { list in
                self.eventDispatcher.event.onNext(.insert(list))
            })
    }

    func delete(isbn13: String) -> Observable<[String]> {
        return fetchBookmark()
            .flatMap { [weak self] list -> Observable<[String]> in
                guard let `self` = self else { return .empty() }
                let newList = list.contains(isbn13) ? list.filter { $0 != isbn13 } : list
                return self.save(newList).map { newList }
            }
            .do(onNext: { list in
                self.eventDispatcher.event.onNext(.delete(list))
            })
    }

    func isBookmarked(isbn13: String) -> Observable<Bool> {
        return fetchBookmark().map { $0.contains(isbn13) }
    }
}

extension Reactive where Base: StorageService {
    var event: Observable<StorageEvent> {
        return base.eventDispatcher.event.asObservable()
    }
}

/*
 MARK: *Deprecated
 extension Defaults {
 @discardableResult
 public func reset<ValueType>(key: Key<ValueType>) -> ValueType? {
 clear(key)
 return get(for: key)
 }
 }
 
 extension Defaults {
 public func appendBookmark(isbn13: String) {
 var list = self.get(for: .bookmarkList) ?? []
 list.contains(isbn13) ? Void() : list.append(isbn13)
 self.set(list, for: .bookmarkList)
 }
 
 public func removeBookmark(isbn13: String) {
 var list = self.get(for: .bookmarkList) ?? []
 list.contains(isbn13) ? list.removeAll(where: { $0 == isbn13 }) : Void()
 self.set(list, for: .bookmarkList)
 }
 }
 */
