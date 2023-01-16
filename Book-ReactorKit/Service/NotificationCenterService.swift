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

private protocol NotificationServiceType {
    var event: PublishSubject<AdvancedGlobalEvent> { get }
    
    @discardableResult
    func notify(event: AdvancedGlobalEvent) -> Observable<AdvancedGlobalEvent>
}

final class NotificationCenterService: BaseService, NotificationServiceType {

    fileprivate let event = PublishSubject<AdvancedGlobalEvent>()
    
    func notify(event: AdvancedGlobalEvent) -> Observable<AdvancedGlobalEvent> {
        return Observable<AdvancedGlobalEvent>.create { observer in
            observer.on(.next(event))
            return Disposables.create()
        }
        .do(onNext: {
            self.event.onNext($0)
        })
    }
}

extension Reactive where Base: NotificationCenterService {
    var event: Observable<AdvancedGlobalEvent> {
        return base.event.asObservable()
    }
}
