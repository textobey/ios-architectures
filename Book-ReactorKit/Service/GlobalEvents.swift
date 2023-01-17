//
//  GlobalEvents.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/15.
//

// MARK: *Deprecated

//import Foundation
//import RxSwift
//import RxCocoa
//
//extension Notification.Name {
//    static let globalEvent = Notification.Name(rawValue: "globalEvent")
//}
//
//typealias GlobalEventDictionary = [String: GlobalEvent]
//
//@dynamicMemberLookup
//struct GlobalEventWrapper {
//    fileprivate var eventDictionary: GlobalEventDictionary
//    subscript(dynamicMember member: String) -> GlobalEvent? {
//        return eventDictionary[member]
//    }
//}
//
//enum GlobalEvent {
//    case willPresentNotification([AnyHashable: Any]?)
//    case didReceiveNotification([AnyHashable: Any]?)
//    case updateBookmarkList
//    case error(String)
//    case none
//
//    private var EVENT_KEY: String {
//        return "global_event"
//    }
//
//    public func convertToUserInfo() -> GlobalEventDictionary {
//        return [EVENT_KEY: self]
//    }
//}
//
//final class GlobalEventsDispatcher: NSObject {
//    public static let shared: GlobalEventsDispatcher = GlobalEventsDispatcher()
//
//    private let disposeBag = DisposeBag()
//    fileprivate let globalEventStream = PublishRelay<GlobalEvent>()
//
//    private override init() {
//        super.init()
//        configure()
//    }
//
//    private func configure() {
//        NotificationCenter.default.rx.notification(.globalEvent)
//            .withUnretained(self)
//            .flatMap { owner, event -> Observable<GlobalEvent> in
//                return owner.convertToGlobalEvent(from: event)
//            }
//            .bind(to: globalEventStream)
//            .disposed(by: disposeBag)
//    }
//
//    private func convertToGlobalEvent(from notification: Notification) -> Observable<GlobalEvent> {
//        guard let dictionary = notification.userInfo as? GlobalEventDictionary else { return Observable.just(.none) }
//        let container = GlobalEventWrapper(eventDictionary: dictionary)
//        return Observable.just(container.global_event ?? .none)
//    }
//}
//
//extension Reactive where Base: GlobalEventsDispatcher {
//    var globalEventStream: Observable<GlobalEvent> {
//        return base.globalEventStream.asObservable()
//    }
//}
