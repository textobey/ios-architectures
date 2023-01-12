//
//  ServiceProviderType.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var notificationCenterService: NotificationCenterService { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var notificationCenterService: NotificationCenterService = NotificationCenterService(provider: self)
}
