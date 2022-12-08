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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.reactor = NewBookReactor()

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
        
        newBookView.tableView.rx.modelSelected(BookItem.self)
            .compactMap { $0.isbn13 }
            .subscribe(onNext: { [weak self] isbn13 in
                let viewController = BookDetailViewController(isbn13: isbn13)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
