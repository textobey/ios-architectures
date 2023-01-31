//
//  SearchBookView.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class SearchBookView: UIView {
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
        $0.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        $0.refreshControl = self.refreshControl
    }
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
}

extension SearchBookView {
    func bind(reactor: SearchBookReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        TypistService.shared.rx.willShow
            .subscribe(onNext: {
                print("ddd")
            }).disposed(by: disposeBag)
    }
}

extension SearchBookView {
    private func bindAction(reactor: SearchBookReactor) {

    }
    
    private func bindState(reactor: SearchBookReactor) {
        reactor.state
            .compactMap { $0.books }
            .bind(to: tableView.rx.items(cellIdentifier: SearchBookTableViewCell.identifier, cellType: SearchBookTableViewCell.self)) { row, item, cell in
                cell.bindView(bookItem: item)
            }.disposed(by: disposeBag)
        
        //keyboardDismiss
        //    .bind(to: tableView.rx.keyboardDismissMode)
        //    .disposed(by: disposeBag)
    }
}
