//
//  NewBookViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class NewBookViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init(reactor: NewBookReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let newBookView = NewBookView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(newBookView)
        newBookView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension NewBookViewController: ReactorKit.View {
    func bind(reactor: NewBookReactor) {
        newBookView.bind(reactor: reactor)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertTrigger)
            .withUnretained(self)
            .flatMap { $0.0.showNewReleaseAlert() }
            .filter { $0 }
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        newBookView.tableView.rx.modelSelected(BookItem.self)
            .compactMap { $0.isbn13 }
            .subscribe(onNext: { [weak self] isbn13 in
                guard let `self` = self else { return }
                let reactor = BookDetailReactor(provider: self.reactor!.provider, isbn13: isbn13)
                let viewController = BookDetailViewController(reactor: reactor)
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension NewBookViewController {
    private func showNewReleaseAlert() -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            let alertController = UIAlertController(
                title: "새로운 책들을 확인해보세요",
                message: "베스트 셀러 작가들의 신규 책들이 발간 되었어요! 받아보시겠어요?",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                observer.onNext(true)
                observer.onCompleted()
            }
            let noAction = UIAlertAction(title: "Later", style: .default) { _ in
                observer.onNext(false)
                observer.onCompleted()
            }
            [okAction, noAction].forEach { alertController.addAction($0) }
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
