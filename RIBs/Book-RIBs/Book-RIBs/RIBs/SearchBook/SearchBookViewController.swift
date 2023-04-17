//
//  SearchBookViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import UIKit
import RIBs
import RxSwift
import RxRelay
import RxSwiftExt
import SnapKit

protocol SearchBookPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func search(for word: String)
    func paging(of word: String)
    func selectedBook(of item: BookItem)
}

final class SearchBookViewController: UIViewController, SearchBookPresentable, SearchBookViewControllable {
    
    private let disposeBag = DisposeBag()

    weak var listener: SearchBookPresentableListener?
    
    var booksStream = BehaviorRelay<[BookItem]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: UI
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private(set) var refreshControl = UIRefreshControl()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
        $0.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        // FIXME: 새로고침 시도중인 상태에서는 Paging 동작하지 않도록 수정
        $0.refreshControl = self.refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        bindAction()
        bindState()
        
        listener?.search(for: "Apple")
    }
    
    private func setupNavigationBar() {
        searchController.searchBar.placeholder = "검색어를 입력해보세요"
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func pushViewController(_ viewController: RIBs.ViewControllable, animated: Bool) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func popViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}

extension SearchBookViewController {
    private func bindState() {
        booksStream
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchBookTableViewCell.identifier,
                cellType: SearchBookTableViewCell.self)
            ) { row, item, cell in
                cell.configureCell(by: item)
            }.disposed(by: disposeBag)
    }
    
    private func bindAction() {
        tableView.rx.modelSelected(BookItem.self)
            .withUnretained(self)
            .map { $0.0.listener?.selectedBook(of: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .withUnretained(self)
            .map { $0.0.listener?.search(for: $0.1 ?? "") }
            .subscribe()
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .skip(1)
            .withUnretained(self)
            .map { $0.0.listener?.paging(of: $0.0.searchController.searchBar.text ?? "") }
            .subscribe()
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.stopLoadingIndicator() })
            .map { $0.0.listener?.search(for: $0.0.searchController.searchBar.text ?? "") }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension SearchBookViewController {
    private func stopLoadingIndicator() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1,
            execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}
