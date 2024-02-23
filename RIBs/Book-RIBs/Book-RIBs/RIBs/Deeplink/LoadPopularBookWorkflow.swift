//
//  LoadPopularBookWorkflow.swift
//  Book-RIBs
//
//  Created by 이서준 on 2/23/24.
//

import Foundation
import RIBs
import RxSwift

class LoadPopularBookWorkflow: Workflow<RootActionableItem> {
    public init(url: URL) {
        super.init()
        
        // TODO: Deeplink URL로 전달받은 아이템이 있을 경우 작업이 추가됨
        
        self.onStep { (rootItem: RootActionableItem) -> Observable<(NewBookActionableItem, String)> in
            rootItem.waitForRequest()
        }
        .onStep { (newBookItem: NewBookActionableItem, string: String)-> Observable<(NewBookActionableItem, ())> in
            print("wait is string? \(string)")
            return newBookItem.loadPopularBooks()
        }
        .commit()
    }
}
