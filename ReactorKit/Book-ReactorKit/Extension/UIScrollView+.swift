//
//  UIScrollView+.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/08/02.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
