//
//  ServiceProviderType.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/12.
//

import Foundation
import RxSwift

protocol ServiceProviderType: AnyObject {
    var storageService: StorageServiceType { get }
    var internalNotificationService: InternalNotificationServiceType { get }
    
    //var storageServiceEventObservable: Observable<StorageEvent> { get }
    //var internalNotificationServiceEventObservable: Observable<InternalNotificationEvent> { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var storageService: StorageServiceType = StorageService(provider: self)
    lazy var internalNotificationService: InternalNotificationServiceType = InternalNotificationService(provider: self)
    
    //var storageServiceEventObservable: Observable<StorageEvent> {
    //    return (storageService as! StorageService).rx.eventStream
    //}
    
    //var internalNotificationServiceEventObservable: Observable<InternalNotificationEvent> {
    //    return (internalNotificationService as! InternalNotificationService).rx.eventStream
    //}
}
