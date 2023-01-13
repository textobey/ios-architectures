//
//  NotificationCenterService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation
import RxSwift
import RxCocoa

enum AdvancedGlobalEvent {
    case willPresentNotification
    case didReceiveNotification(String)
    case updateBookmarkList
    case error(String)
    case none
}

protocol NotificationServiceType {
    var event: PublishSubject<AdvancedGlobalEvent> { get }
    
    @discardableResult
    func notify(event: AdvancedGlobalEvent) -> Observable<AdvancedGlobalEvent>
}

final class NotificationCenterService: BaseService, NotificationServiceType {

    let event = PublishSubject<AdvancedGlobalEvent>()
    
    private var `deafult`: NotificationCenter {
        return NotificationCenter.default
    }
    
    func notify(event: AdvancedGlobalEvent) -> Observable<AdvancedGlobalEvent> {
        return Observable<AdvancedGlobalEvent>.create { observer in
            observer.on(.next(event))
            return Disposables.create()
        }
        .do(onNext: {
            self.event.onNext($0)
        })
    }
    
    //TODO: NotificationCenter로 해결하지 않고,
    //post라는 메서드를 만들어서, 이걸로 직접 GlobalEvent에 이벤트를 accept해주는 구조로 수정하자.
    //나머지는 RxToDo에 맞춰서 수정하고..
    
    // 1. provier.event를 통해 switch 문으로 받아야함
    // 2. 글로벌 이벤트가 발생하는곳에서 이벤트가 발생했음을 알려줌
    // 3. event에 onNext해줘야함
}
