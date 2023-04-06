//
//  Then.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit

protocol Then {}

extension Then where Self: AnyObject {
    
    /// 초기화 후에 클로저로 프로퍼티를 설정할 수 있도록 합니다.
    ///
    /// - Parameter closure: 클로저
    /// - Returns: Self 오브젝트
    ///
    /// ```
    /// let label = UILabel().then {
    ///     $0.textAlignment = .center
    ///     $0.textColor = UIColor.red
    ///     $0.text = "Text"
    /// }
    /// ```
    ///
    func then(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
}

extension Then where Self: Any {
    
    func then(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
}

extension NSObject: Then {}
extension DateComponents: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
