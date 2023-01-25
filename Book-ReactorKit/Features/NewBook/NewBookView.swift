//
//  NewBookView.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

final class NewBookView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewBookTableViewCell.self, forCellReuseIdentifier: NewBookTableViewCell.identifier)
        $0.refreshControl = self.refreshControl
    }
    
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        addSubview(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension NewBookView {
    func bind(reactor: NewBookReactor) {
        self.bindAction(reactor: reactor)
        self.bindState(reactor: reactor)
    }
}

extension NewBookView {
    private func bindAction(reactor: NewBookReactor) {
        self.tableView.rx.contentOffset.withUnretained(self)
            .filter { $0.0.tableView.isNearBottomEdge() }
            .map { _ in NewBookReactor.Action.paging }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.stopLoadingIndicator() })
            .map { _ in NewBookReactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: NewBookReactor) {
        reactor.state
            .compactMap { $0.books }
            .bind(to: self.tableView.rx.items(
                cellIdentifier: NewBookTableViewCell.identifier,
                cellType: NewBookTableViewCell.self)
            ) { row, bookItem, cell in
                cell.configureCell(by: bookItem)
                cell.bookmarkTap
                    .map { NewBookReactor.Action.bookmark($0, bookItem) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.loadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension NewBookView {
    private func stopLoadingIndicator() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1,
            execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}
