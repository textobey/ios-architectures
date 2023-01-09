////
////  NotificationService.swift
////  Book-ReactorKit
////
////  Created by 이서준 on 2022/12/13.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class NotificationService {
//    /// singleton property
//    static let shared: NotificationService = NotificationService()
//
//    // dispose
//    private let disposeBag = DisposeBag()
//    // for observable stream
//    var globalEventStream = PublishRelay<InternalNotification>()
//
//    private init() { }
//
//    /// Never duplicate calls
//    private func getReadyToGetNotification() {
//
//    }
//}
//
//extension NotificationService {
//    func fetchGlobalEventStream() -> Observable<InternalNotification> {
//        return Observable<InternalNotification>.create { observer in
//
//            let observable = InternalNotificationCenter.allCases.map { notification -> Observable<InternalNotification> in
//                return notification.addObserver()
//            }.map { notification in
//                notification.subscribe(onNext: { event in
//                    observer.onNext(event)
//                    observer.onCompleted()
//                })
//            }
//
//            return Disposables.create {
//                observable.forEach {
//                    $0.dispose()
//                }
//            }
//        }
//    }
//}
//
//
