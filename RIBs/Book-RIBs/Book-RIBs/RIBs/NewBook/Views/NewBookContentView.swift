//
//  NewBookContentView.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NewBookContentView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - stored properties
    lazy var topView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    lazy var bottomView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    lazy var topImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var bookmarkIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.setImage(UIImage(systemName: "star.fill"), for: .selected)
        $0.tintColor = .black.withAlphaComponent(0.6)
    }
    
    lazy var bottomStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }

    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    // MARK: - initialize methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.bindRx()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayout()
    }
    
    func setupLayout() {
        addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        topView.addSubview(topImageView)
        topImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-25)
            // FIXME: - 데이터 받으면
            $0.width.equalTo(100)
            $0.height.equalTo(140)
            //
            $0.centerX.equalToSuperview()
        }
        
        addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(bookmarkIcon)
        bookmarkIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(22)
            $0.height.equalTo(20)
        }
        
        [titleLabel, subtitleLabel, isbn13Label, priceLabel].forEach {
            bottomStackView.addArrangedSubview($0)
        }
    }
    
    private func bindRx() {
        bookmarkIcon.rx.tap
            .withUnretained(self)
            .map { !$0.0.bookmarkIcon.isSelected }
            .bind(to: bookmarkIcon.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
