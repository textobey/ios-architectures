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

private protocol InternalNotificationServiceType {
    var event: PublishSubject<InternalNotificationEvent> { get }
    
    func notify(event: InternalNotificationEvent) -> Observable<InternalNotificationEvent>
}

final class InternalNotificationService: BaseService, InternalNotificationServiceType {

    fileprivate let event = PublishSubject<InternalNotificationEvent>()
    
    @discardableResult
    func notify(event: InternalNotificationEvent) -> Observable<InternalNotificationEvent> {
        return Observable<InternalNotificationEvent>.create { observer in
            observer.on(.next(event))
            return Disposables.create()
        }
        .do(onNext: {
            self.event.onNext($0)
        })
    }
}

extension Reactive where Base: InternalNotificationService {
    var event: Observable<InternalNotificationEvent> {
        return base.event.asObservable()
    }
}
