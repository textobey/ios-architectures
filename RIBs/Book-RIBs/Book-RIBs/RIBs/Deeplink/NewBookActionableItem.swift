//
//  NewBookActionableItem.swift
//  Book-RIBs
//
//  Created by 이서준 on 2/23/24.
//

import RxSwift

public protocol NewBookActionableItem: AnyObject {
    func loadPopularBooks() -> Observable<(NewBookActionableItem, ())>
}
