//
//  UserDefaultsService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/16.
//

import Foundation

extension DefaultsKey {
    static let bookmarkList = Key<[String]>("bookmark_list")
}

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
}
