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
        defer { self.reactor = BookDetailReactor(isbn13: isbn13) }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bookTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    lazy var bookDetailView = BookDetailView().then {
        $0.backgroundColor = .white
        $0.textView.delegate = self
        $0.textView.returnKeyType = .done
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.bookTitleLabel)
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.bookDetailView)
        
        self.bookTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.bookTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.bookDetailView.snp.makeConstraints {
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

// MARK: - text view delegate
extension BookDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // FIXME: - keyboard 높이만큼 scroll view도 올라가야함 -> NotificationCenter
        if textView.textColor != .black {
            textView.text.removeAll()
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let title = self.bookTitleLabel.text else { return }
        guard let text = textView.text else { return }
        
        if textView.textColor == .systemGray3 || text == "" {
            self.bookDetailView.textView.text = "메모를 입력해보세요"
            self.bookDetailView.textView.textColor = .systemGray3
            if UserDefaults.standard.string(forKey: title) != nil {
                UserDefaults.standard.removeObject(forKey: title)
            }
        } else {
            UserDefaults.standard.set(text, forKey: title)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            // MARK: - keyboard 내려갈때 scrollView도 내려가기 -> NotificationCenter
            return false
        }
        return true
    }
}
