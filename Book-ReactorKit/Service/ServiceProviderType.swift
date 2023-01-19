//
//  ServiceProviderType.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var storageService: StorageServiceType { get }
    var internalNotificationService: InternalNotificationServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var storageService: StorageServiceType = StorageService(provider: self)
    lazy var internalNotificationService: InternalNotificationServiceType = InternalNotificationService(provider: self)
}
