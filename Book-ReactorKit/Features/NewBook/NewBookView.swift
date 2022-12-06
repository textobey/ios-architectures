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

class NewBookView: UIView {
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewBookTableViewCell.self, forCellReuseIdentifier: NewBookTableViewCell.identifier)
        $0.refreshControl = self.refreshControl
        $0.refreshControl?.addTarget(self, action: #selector(self.handleRefreshControl), for: .valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension NewBookView {
    @objc func handleRefreshControl() {
        self.tableView.refreshControl?.endRefreshing()
    }
}

extension NewBookView {
    func bind(reactor: NewBookReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

extension NewBookView {
    private func bindAction(reactor: NewBookReactor) {
        tableView.rx.contentOffset.withUnretained(self)
            .filter { $0.0.tableView.isNearBottomEdge() }
            .map { _ in NewBookReactor.Action.paging }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in NewBookReactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: NewBookReactor) {
        reactor.state
            .compactMap { $0.books }
            .bind(to: tableView.rx.items(cellIdentifier: NewBookTableViewCell.identifier, cellType: NewBookTableViewCell.self)) { row, bookItem, cell in
                cell.configureCell(by: bookItem)
            }.disposed(by: disposeBag)
    }
}
