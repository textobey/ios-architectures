//
//  GlobalEvents.swift
//  Book-ReactorKit
//
//  Created by 이서준 onwlsWk  2022/12/15.
//

import Foundation
import RxSwift
import RxCocoa

extension Notification.Name {
    static let globalEvent = Notification.Name(rawValue: "globalEvent")
}

enum GlobalEvent {
    case willPresentNotification([AnyHashable: Any]?)
    case didReceiveNotification([AnyHashable: Any]?)
    case updateBookmarkList
    case error(String)
    case none
    
    private var EVENT_KEY: String {
        return "globalEvent"
    }
    
    public func convertToUserInfo() -> [AnyHashable : Any] {
        return [EVENT_KEY: self]
    }
}

final class GlobalEventsDispatcher: NSObject {
    public static let shared: GlobalEventsDispatcher = GlobalEventsDispatcher()
    
    private let disposeBag = DisposeBag()
    fileprivate let globalEventStream = PublishRelay<GlobalEvent>()
    
    private override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        NotificationCenter.default.rx.notification(.globalEvent)
            .withUnretained(self)
            .flatMap { owner, event -> Observable<GlobalEvent> in
                return owner.convertToGlobalEvent(from: event)
            }
            .bind(to: globalEventStream)
            .disposed(by: disposeBag)
    }
    
    private func convertToGlobalEvent(from notification: Notification) -> Observable<GlobalEvent> {
        let globalEvents = notification.userInfo?.compactMap { $0.value as? GlobalEvent } ?? []
        return Observable.from(globalEvents)
    }
}

extension Reactive where Base: GlobalEventsDispatcher {
    var globalEventStream: Observable<GlobalEvent> {
        return base.globalEventStream.asObservable()
    }
}
