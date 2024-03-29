//
//  InternalNotificationService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

enum InternalNotificationEvent {
    case willPresentNotification
    case didReceiveNotification(String)
    case updateBookmarkList
    case error(String)
    case none
}

final class InternalNotificationEventDispatcher: NSObject {
    fileprivate let event = PublishSubject<InternalNotificationEvent>()
}

protocol InternalNotificationServiceType {
    var eventDispatcher: InternalNotificationEventDispatcher { get }
    
    @discardableResult
    func notify(event: InternalNotificationEvent) -> Observable<InternalNotificationEvent>
}

final class InternalNotificationService: BaseService, InternalNotificationServiceType {

    let eventDispatcher: InternalNotificationEventDispatcher = InternalNotificationEventDispatcher()
    
    func notify(event: InternalNotificationEvent) -> Observable<InternalNotificationEvent> {
        defer {
            self.eventDispatcher.event.onNext(event)
        }
        return Observable.just(event)
    }
}

extension Reactive where Base: InternalNotificationEventDispatcher {
    var eventStream: Observable<InternalNotificationEvent> {
        return base.event.asObservable()
    }
}
