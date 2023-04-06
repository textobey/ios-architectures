//
//  Array+.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/05.
//

import Foundation

extension Array {
    /// outofrange를 피하기위해 안전하게 배열의 값을 가져오는 서브스크립트
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.endIndex > endIndex {
            if range.startIndex >= endIndex { return nil } else { return self[range.startIndex ..< endIndex] }
        } else {
            return self[range]
        }
    }
}
