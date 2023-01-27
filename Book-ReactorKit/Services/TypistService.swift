//
//  TypistService.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2023/01/27.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: 백그라운드 또는 현재 Display 상태가 아닌 화면에서는 이벤트 수신하지 않도록, 선택적으로 구조 변경

enum TypistEvent {
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame
}

final class TypistEventDispatcher: NSObject {
    fileprivate let event = PublishSubject<TypistEvent>()
}

protocol TypistServiceType {
    var eventDispatcher: TypistEventDispatcher { get }
    
    //@discardableResult
    //func start()
}

final class TypistService: BaseService, TypistServiceType {
    
    let eventDispatcher: TypistEventDispatcher = TypistEventDispatcher()
    
    private let `default` = NotificationCenter.default
    
    func start() {
        
    }
    
    func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) {
        var endFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            endFrame = value
        }
        
        var startFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            startFrame = value
        }
    }
}

private extension TypistEvent {
    var notification: Notification.Name {
        switch self {
        case .willShow:
            return UIResponder.keyboardWillShowNotification
            
        case .didShow:
            return UIResponder.keyboardDidShowNotification
            
        case .willHide:
            return UIResponder.keyboardWillHideNotification
            
        case .didHide:
            return UIResponder.keyboardDidHideNotification
            
        case .willChangeFrame:
            return UIResponder.keyboardWillChangeFrameNotification
            
        case .didChangeFrame:
            return UIResponder.keyboardDidChangeFrameNotification
        }
    }
}
