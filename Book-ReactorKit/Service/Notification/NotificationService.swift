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
    
    private let disposeBag = DisposeBag()
    
    var event = PublishRelay<NotificationServiceEvent>()
    
    private var notificationNames: [Notification.Name] {
        return self.fetchNotificationNames()
    }
    
    private init() {
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.rx
            .notification(.willPresentNotification)
            .observe(on: MainScheduler.instance)
            .map { _ in NotificationServiceEvent.willPresent }
            .bind(to: event)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.didReceiveNotification)
            .observe(on: MainScheduler.instance)
            .map { _ in NotificationServiceEvent.willPresent }
            .bind(to: event)
            .disposed(by: disposeBag)
    }
    
    private func fetchNotificationNames() -> [Notification.Name] {
        return [.willPresentNotification, .didReceiveNotification]
    }
}
