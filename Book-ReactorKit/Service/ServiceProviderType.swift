//
//  ServiceProviderType.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var storageService: StorageService { get }
    var internalNotificationService: InternalNotificationService { get }
}

final class ServiceProvider: ServiceProviderType {
    // TODO: 싱글턴 패턴 차용하지 않기
    static let shared: ServiceProvider = ServiceProvider()
    
    private init() { }
    lazy var storageService: StorageService = StorageService(provider: self)
    lazy var internalNotificationService: InternalNotificationService = InternalNotificationService(provider: self)
}
