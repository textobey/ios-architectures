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

final class TypistEventDispatcher {
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

// TODO: IoC 구조로 다시 변경하기. NSObject 상속이 필요한 부분은 TypistEventDispatcher로 옮기기
// TODO: 정리해놓은 Swift Style Guide 적용하기
final class TypistService: NSObject { //BaseService, TypistServiceType {
    
    private let `default` = NotificationCenter.default
    let eventDispatcher: TypistEventDispatcher = TypistEventDispatcher()
    
    static let shared = TypistService()
    
    private(set) var acceptable: Bool = true
    
    func start() {
        TypistEvent.allCases.forEach {
            self.default.addObserver(self, selector: $0.selector, name: $0.notification, object: nil)
        }
//        TypistEvent.allCases.map {
//            keyboardOptions(fromNotificationDictionary: $0.notification) $0.notification
//            self.default.rx.notification($0.notification)
//        }
    }
    
    func stop() {
        self.default.removeObserver(self)
    }
    
    func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> KeyboardOptions {
        var currentApp = true
        if let value = (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
            currentApp = value
        }
        
        var endFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            endFrame = value
        }
        
        var startFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            startFrame = value
        }
        
        var animationCurve = UIView.AnimationCurve.linear
        if let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let value = UIView.AnimationCurve(rawValue: index) {
            animationCurve = value
        }
        
        var animationDuration: Double = 0.0
        if let value = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            animationDuration = value
        }
        
        return KeyboardOptions(
            belongsToCurrentApp: currentApp,
            startFrame: startFrame,
            endFrame: endFrame,
            animationCurve: animationCurve,
            animationDuration: animationDuration
        )
    }
    
    @objc func keyboardWillShow(note: Notification) -> KeyboardOptions {
        return self.keyboardOptions(fromNotificationDictionary: note.userInfo)
    }

    @objc func keyboardDidShow(note: Notification) {
        keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    
    @objc func keyboardWillHide(note: Notification) {
        keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    
    @objc func keyboardDidHide(note: Notification) {
        keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    
    @objc func keyboardDidChangeFrame(note: Notification) {
        keyboardOptions(fromNotificationDictionary: note.userInfo)
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

// TODO: NSObject 상속으로 인해서 class로 변경하였는데, struct(값타입) 구조로 다시 변경할 방법이 없을지..
class KeyboardOptions: NSObject {
    /// Identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
    let belongsToCurrentApp: Bool
    
    /// Identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
    let startFrame: CGRect
    
    /// Identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
    let endFrame: CGRect
    
    /// Constant that defines how the keyboard will be animated onto or off the screen.
    let animationCurve: UIView.AnimationCurve
    
    /// Identifies the duration of the animation in seconds.
    let animationDuration: Double
    
    /// Maps the animationCurve to it's respective `UIView.AnimationOptions` value.
    var animationOptions: UIView.AnimationOptions {
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
    
    init(belongsToCurrentApp: Bool = true,
         startFrame: CGRect = CGRect(),
         endFrame: CGRect = CGRect(),
         animationCurve: UIView.AnimationCurve = .linear,
         animationDuration: Double = 0.0
    ) {
        self.belongsToCurrentApp = belongsToCurrentApp
        self.startFrame = startFrame
        self.endFrame = endFrame
        self.animationCurve = animationCurve
        self.animationDuration = animationDuration
    }
}

extension Reactive where Base: TypistService {
    // TODO: KeyboardOptions로 타입캐스팅하여 리턴하기
    var willShow: Observable<Void> {
        return methodInvoked(#selector(base.keyboardWillShow(note:)))
            .map {
                print($0[0])
            }
    }
}
