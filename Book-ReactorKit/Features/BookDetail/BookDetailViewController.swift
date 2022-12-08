//
//  BookDetailViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class BookDetailViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init(isbn13: String) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = BookDetailReactor(isbn13: isbn13)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var scrollContainerView = UIView()
    
    lazy var bookDetailView = BookDetailView().then {
        $0.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail Book"
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.centerX.equalToSuperview()
        }
        
        scrollContainerView.addSubview(bookDetailView)
        bookDetailView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}

extension BookDetailViewController: ReactorKit.View {
    func bind(reactor: BookDetailReactor) {
        bookDetailView.bind(reactor: reactor)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
