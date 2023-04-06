//
//  UITableView+.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/16.
//

import UIKit

extension UITableView {
    func isLast(for indexPath: IndexPath) -> Bool {
        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1
        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}
