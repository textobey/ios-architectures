//
//  SearchBookViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class SearchBookViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init() {
        defer { self.reactor = SearchBookReactor() }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    let searchBookView = SearchBookView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
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
        view.addSubview(searchBookView)
        searchBookView.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchBookViewController: ReactorKit.View {
    func bind(reactor: SearchBookReactor) {
        searchBookView.bind(reactor: reactor)
        
        searchBookView.tableView.rx.contentOffset
            .withUnretained(self)
            .do(onNext: { $0.0.searchController.searchBar.endEditing(true) })
            .filter { $0.0.searchBookView.tableView.isNearBottomEdge() }
            .map { Reactor.Action.paging($0.0.searchController.searchBar.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBookView.refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.stopLoadingIndicator() })
            .map { Reactor.Action.phraseSearch($0.0.searchController.searchBar.text ?? "")}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .map { SearchBookReactor.Action.phraseSearch($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension SearchBookViewController {
    private func stopLoadingIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.searchBookView.tableView.refreshControl?.endRefreshing()
        })
    }
}
