//
//  RootActionableItem.swift
//  Book-RIBs
//
//  Created by 이서준 on 2/23/24.
//

import RxSwift

public protocol RootActionableItem: AnyObject {
    //func waitForRequest() -> Observable<(NewBookActionableItem, ())>
    func waitForRequest() -> Observable<(NewBookActionableItem, String)>
}
