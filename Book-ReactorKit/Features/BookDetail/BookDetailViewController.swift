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
    
    init(reactor: BookDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bookmark = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.setImage(UIImage(systemName: "star.fill"), for: .selected)
        $0.tintColor = .black.withAlphaComponent(0.6)
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
        setupNavigationBar()
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
    
    private func setupNavigationBar() {
        let item = UIBarButtonItem(customView: bookmark)
        navigationItem.rightBarButtonItem = item
    }
}

extension BookDetailViewController: ReactorKit.View {
    func bind(reactor: BookDetailReactor) {
        bookDetailView.bind(reactor: reactor)
        
        reactor.state
            .map { $0.isBookmarked }
            .bind(to: bookmark.rx.isSelected)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmark.rx.tap
            .map { Reactor.Action.bookmark }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
