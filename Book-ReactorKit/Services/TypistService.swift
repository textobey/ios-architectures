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

enum TypistEvent: CaseIterable {
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
    func start()
    //func keyboardWillShow(note: Notification)
    //func keyboardDidShow(note: Notification)
    //func keyboardWillHide(note: Notification)
    //func keyboardDidHide(note: Notification)
    //func keyboardWillChangeFrame(note: Notification)
    //func keyboardDidChangeFrame(note: Notification)
}

final class TypistService: BaseService, TypistServiceType {
    
    private let `default` = NotificationCenter.default
    let eventDispatcher: TypistEventDispatcher = TypistEventDispatcher()
    
    private(set) var acceptable: Bool = true
    
    func start() {
        TypistEvent.allCases.forEach {
            self.default.addObserver(self, selector: $0.selector, name: $0.notification, object: nil)
        }
    }
    
    func stop() {
        self.default.removeObserver(self)
    }
    
    
    func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) { //-> KeyboardOptions {
        if let value = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber {
            let isCurrent = value.boolValue
        }
        
        if let value = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let endFrame = value.cgRectValue
        }
        
        if let value = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let startFrame = value.cgRectValue
        }
        
        //TODO: return KeyboardOptions로 리턴하기
        //return KeyboardOptions
    }
    
    @objc func keyboardWillShow(note: Notification) { //-> Observable<KeyboardOptions> {
        //TODO: KeyboardOptions 인스턴스를 생성하여 Observable stream of keyboardOptions return
        //return Observable.just(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc func keyboardDidShow(note: Notification) {
    
    }
    
    @objc func keyboardWillHide(note: Notification) {
        
    }
    
    @objc func keyboardDidHide(note: Notification) {
    
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
    
    }
    
    @objc func keyboardDidChangeFrame(note: Notification) {
    
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
    
    var selector: Selector {
        switch self {
        case .willShow:
            return #selector(TypistService.keyboardWillShow(note:))
            
        case .didShow:
            return #selector(TypistService.keyboardDidShow(note:))
            
        case .willHide:
            return #selector(TypistService.keyboardWillHide(note:))
            
        case .didHide:
            return #selector(TypistService.keyboardDidHide(note:))
            
        case .willChangeFrame:
            return #selector(TypistService.keyboardWillChangeFrame(note:))
            
        case .didChangeFrame:
            return #selector(TypistService.keyboardDidChangeFrame(note:))
        }
    }
}

public struct KeyboardOptions {
    /// Identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
    public let belongsToCurrentApp: Bool
    
    /// Identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
    public let startFrame: CGRect
    
    /// Identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
    public let endFrame: CGRect
    
    /// Constant that defines how the keyboard will be animated onto or off the screen.
    public let animationCurve: UIView.AnimationCurve
    
    /// Identifies the duration of the animation in seconds.
    public let animationDuration: Double
    
    /// Maps the animationCurve to it's respective `UIView.AnimationOptions` value.
    public var animationOptions: UIView.AnimationOptions {
        switch self.animationCurve {
        case UIView.AnimationCurve.easeIn:
            return UIView.AnimationOptions.curveEaseIn
        case UIView.AnimationCurve.easeInOut:
            return UIView.AnimationOptions.curveEaseInOut
        case UIView.AnimationCurve.easeOut:
            return UIView.AnimationOptions.curveEaseOut
        case UIView.AnimationCurve.linear:
            return UIView.AnimationOptions.curveLinear
        @unknown default:
            fatalError()
        }
    }
}
