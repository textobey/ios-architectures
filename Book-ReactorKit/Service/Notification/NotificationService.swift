//
//  NotificationService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/13.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationService: GlobalEventsProtocol {
    
    static let shared: NotificationService = NotificationService()
    
    private let disposeBag = DisposeBag()
    
    var globalEventStream = PublishRelay<GlobalEvents>()
    
    private init() { }
    
    /// Never duplicate calls
    func addObservers() {
        InternalNotificationCenter.allCases.forEach { name in
            name.addObserver().map { object in
                name.transform(object)
            }
            .bind(to: globalEventStream)
            .disposed(by: disposeBag)
        }
    }
}

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(self.name).map { $0.object }
    }
    
    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: userInfo)
    }
}

enum InternalNotificationCenter: NotificationCenterProtocol, CaseIterable {
    case willPresentNotification
    case didReceiveNotification
    case updatedBookmarkList
    case other
    
    var name: Notification.Name {
        switch self {
        case .willPresentNotification:
            return Notification.Name(rawValue: "willPresentNotification")
        case .didReceiveNotification:
            return Notification.Name(rawValue: "didReceiveNotification")
        case .updatedBookmarkList:
            return Notification.Name(rawValue: "updatedBookmarkList")
        case .other:
            return Notification.Name(rawValue: "other")
        }
    }
    
    func transform(_ object: Any?) -> GlobalEvents {
        switch self {
        case .willPresentNotification:
            return .willPresentNotification((object as! [AnyHashable : Any]))
        case .didReceiveNotification:
            return .didReceiveNotification((object as! [AnyHashable : Any]))
        case .updatedBookmarkList:
            return .updatedBookmarkList
        case .other:
            return .none
        }
    }
}
