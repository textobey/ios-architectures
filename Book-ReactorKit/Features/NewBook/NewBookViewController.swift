//
//  NewBookViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import RxSwift
import SnapKit
import ReactorKit

class NewBookViewController: UIViewController {
    
    var reactor: NewBookReactor?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let newBookView = NewBookView()
    
    init(reactor: NewBookReactor? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

extension NewBookViewController: View {
    func bind(reactor: NewBookReactor) {
        Observable.just(())
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.books }
            .subscribe(onNext: { books in
                print(books)
            }).disposed(by: disposeBag)
    }
}
