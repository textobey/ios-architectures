//
//  NewBookViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

class NewBookViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    let newBookView = NewBookView()
    
    init() {
        defer { self.reactor = NewBookReactor() }
        super.init(nibName: nil, bundle: nil)
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

extension NewBookViewController: ReactorKit.View {
    func bind(reactor: NewBookReactor) {
        newBookView.bind(reactor: reactor)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
