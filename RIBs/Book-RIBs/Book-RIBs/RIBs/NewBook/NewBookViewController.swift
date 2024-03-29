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
import RxSwiftExt
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
    var isLoading = PublishRelay<Bool>()
    
    // MARK: UI
    
    private let refreshControl = UIRefreshControl()
    
    private let loadingIndicator = UIActivityIndicatorView()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(NewBookTableViewCell.self, forCellReuseIdentifier: NewBookTableViewCell.identifier)
        $0.refreshControl = self.refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindAction()
        bindState()
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
    
    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func popViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func showLoadAlertForPopularBookConfirm() {
        let alert = UIAlertController(title: nil, message: "새로운 인기 책 목록을 불러올까요?", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "네", style: .default) { _ in
            print("TODO: 새로운 책 목록 불러오기")
        }
        
        let actionNo = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewBookViewController {
    private func bindState() {
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
                        ? self?.listener?.createBookmark(of: bookItem)
                        : self?.listener?.undoBookmark(of: bookItem)
                    }
                    .subscribe()
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        isLoading.distinctUntilChanged()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        isLoading.distinctUntilChanged()
            .map { !$0 }
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        tableView.rx.modelSelected(BookItem.self)
            .withUnretained(self)
            .map { $0.0.listener?.selectedBook(of: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom()
            .skip(1)
            .withUnretained(self)
            .map { $0.0.listener?.paging() }
            .subscribe()
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .do(onNext: { $0.0.stopLoadingIndicator() })
            .map { $0.0.listener?.refresh() }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension NewBookViewController {
    private func stopLoadingIndicator() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1,
            execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}
