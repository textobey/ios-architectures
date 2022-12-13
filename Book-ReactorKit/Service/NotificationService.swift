//
//  NotificationService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/13.
//

import UIKit
import RxSwift
import RxCocoa

protocol NotificationServiceProtocol {
    var event: PublishRelay<NotificationServiceEvent> { get }
}

enum NotificationServiceEvent {
    case willPresent
    case didReceive([AnyHashable: Any])
    case error
}

class NotificationService: NotificationServiceProtocol {
    
    static let shared: NotificationService = NotificationService()
    
    var event = PublishRelay<NotificationServiceEvent>()
    
    private init() {
    }
}
