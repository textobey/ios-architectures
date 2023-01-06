//
//  InternalNotificationCenter.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/23.
//


import UIKit
import RxSwift
import RxCocoa

struct InternalNotification {
    let type: InternalNotificationCenter
    let name: Notification.Name
    let object: Any?
    let userInfo: [AnyHashable: Any]?
}

//protocol NotificationCenterProtocol {
//    var name: Notification.Name { get }
//}

enum InternalNotificationCenter: CaseIterable {
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
}

extension InternalNotificationCenter {
    func addObserver() -> Observable<InternalNotification> {
        return NotificationCenter.default.rx.notification(self.name).map { notification in
            InternalNotification(
                type: self,
                name: notification.name,
                object: notification.object,
                userInfo: notification.userInfo
            )
        }
    }
    
    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: userInfo)
    }
}
