//
//  BookDetailViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

protocol BookDetailPresentableListener: AnyObject {
    func popViewController(_ animated: Bool)
}

final class BookDetailViewController: UIViewController, BookDetailPresentable, BookDetailViewControllable {
    
    private let disposeBag = DisposeBag()
    
    private let detachAction = PublishRelay<Void>()

    weak var listener: BookDetailPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindAction()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // isMovingFromParent = UIViewController에서 이 UIViewController가 제거 될 때 true
        // isBeingDismissed = UIViewController가 Dimiss될 때, true
        guard isMovingFromParent || isBeingDismissed else { return }
        detachAction.accept(Void())
    }
    
    private func setupLayout() {
        
    }
}

extension BookDetailViewController {
    private func bindState() {

    }
    
    private func bindAction() {
        detachAction
            .withUnretained(self)
            .map { $0.0.listener?.popViewController(true) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
