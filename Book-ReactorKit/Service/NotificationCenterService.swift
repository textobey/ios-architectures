//
//  NotificationCenterService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol NotificationServiceType {
    var event: PublishSubject<GlobalEvent> { get }
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?)
}

final class NotificationCenterService: BaseService, NotificationServiceType {
    
    let event = PublishSubject<GlobalEvent>()
    
    private var `deafult`: NotificationCenter {
        return NotificationCenter.default
    }

    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?) {
        return self.deafult.post(name: .globalEvent, object: anObject, userInfo: aUserInfo)
    }
}
