//
//  RootViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        super.pushViewController(viewController.uiviewController, animated: animated)
    }
}
