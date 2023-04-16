//
//  BookDetailViewController.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

protocol BookDetailPresentableListener: AnyObject {
    func popViewController(_ animated: Bool)
}

final class BookDetailViewController: UIViewController, BookDetailPresentable, BookDetailViewControllable {
    
    private let disposeBag = DisposeBag()
    
    private let detachAction = PublishRelay<Void>()

    weak var listener: BookDetailPresentableListener?
    
    // MARK: UI
    
    lazy var boxView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 6
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var urlLinkLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .systemBlue
        $0.text = nil
    }
    
    lazy var textView = UITextView().then {
        $0.text = "메모를 입력해보세요"
        $0.delegate = self
        $0.returnKeyType = .done
        $0.textColor = .systemGray3
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Detail"
        view.backgroundColor = .systemBackground
        setupLayout()
        bindAction()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // isMovingFromParent = UIViewController에서 이 UIViewController가 제거 될 때 true
        // isBeingDismissed = UIViewController가 Dimiss될 때, true
        guard isMovingFromParent || isBeingDismissed else { return }
        detachAction.accept(Void())
    }
    
    private func setupLayout() {
        view.addSubview(boxView)
        boxView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(230)
        }
        
        boxView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(boxView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(230)
        }
        
        [titleLabel, subtitleLabel, isbn13Label, priceLabel, urlLinkLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}

extension BookDetailViewController {
    private func bindState() {

    }
    
    private func bindAction() {
        detachAction
            .withUnretained(self)
            .map { $0.0.listener?.popViewController(true) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: - TextViewDelegate

extension BookDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // FIXME: - keyboard 높이만큼 scroll view도 올라가야함 -> NotificationCenter
        if textView.textColor != .black {
            textView.text.removeAll()
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let title = self.titleLabel.text else { return }
        guard let text = textView.text else { return }
        
        if textView.textColor == .systemGray3 || text == "" {
            self.textView.text = "메모를 입력해보세요"
            self.textView.textColor = .systemGray3
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
