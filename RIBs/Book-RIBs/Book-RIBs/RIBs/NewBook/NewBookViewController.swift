//
//  NewBookViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import SnapKit

protocol NewBookPresentableListener: AnyObject {
    func refresh()
    func paging()
    func createBookmark(of item: BookItem)
    func undoBookmark(of item: BookItem)
    func selectedBook(of item: BookItem)
}

final class NewBookViewController: UIViewController, NewBookPresentable, NewBookViewControllable {
    
    var disposeBag = DisposeBag()

    weak var listener: NewBookPresentableListener?
    
    var booksStream = BehaviorRelay<[BookItem]>(value: [])
    
    private let refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewBookTableViewCell.self, forCellReuseIdentifier: NewBookTableViewCell.identifier)
        $0.refreshControl = self.refreshControl
    }
    
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener?.refresh()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindUI() {
        booksStream
            .skip(1)
            .bind(to: self.tableView.rx.items(
                cellIdentifier: NewBookTableViewCell.identifier,
                cellType: NewBookTableViewCell.self)
            ) { row, bookItem, cell in
                cell.configureCell(by: bookItem)
                cell.bookmarkTap
                    .map { [weak self] isSelected in
                        isSelected
                        ? self?.listener?.undoBookmark(of: bookItem)
                        : self?.listener?.createBookmark(of: bookItem)
                    }
                    .subscribe()
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
    }
}
