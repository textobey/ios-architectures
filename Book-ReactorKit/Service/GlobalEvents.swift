//
//  GlobalEvents.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/15.
//

import Foundation
import RxCocoa

protocol GlobalEventsProtocol {
    var globalEventStream: PublishRelay<GlobalEvents> { get }
}

enum GlobalEvents {
    case willPresentNotification([AnyHashable: Any]?)
    case didReceiveNotification([AnyHashable: Any]?)
    case error
    case none
}
