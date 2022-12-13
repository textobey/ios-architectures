//
//  GlobalEvents.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/13.
//

import UIKit
import RxSwift
import RxCocoa

class GlobalEvents {
    private let disposeBag = DisposeBag()
    
    let notificationEvent = PublishRelay<NotificationServiceEvent>()
    
    init() {
        bindGlobalEvents()
    }
    
    private func bindGlobalEvents() {
        NotificationService.shared.event
            .bind(to: notificationEvent)
            .disposed(by: disposeBag)
    }
}
