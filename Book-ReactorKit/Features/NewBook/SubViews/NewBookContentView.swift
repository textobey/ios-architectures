//
//  NewBookContentView.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import SnapKit

class NewBookContentView: UIView {
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayout()
    }
}

// MARK: - set up view methods
extension NewBookContentView {
    func setupLayout() {
        self.backgroundColor = .white
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.addSubview(self.topView)
        self.addSubview(self.bottomView)
        
        self.topView.addSubview(self.topImageView)
        
        self.bottomView.addSubview(self.bottomStackView)
        
        self.bottomStackView.addArrangedSubview(self.titleLabel)
        self.bottomStackView.addArrangedSubview(self.subtitleLabel)
        self.bottomStackView.addArrangedSubview(self.isbn13Label)
        self.bottomStackView.addArrangedSubview(self.priceLabel)
        
        self.topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints {
            $0.top.equalTo(self.topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.topImageView.snp.makeConstraints {
            $0.top.equalTo(self.topView).offset(25)
            $0.bottom.equalTo(self.topView).offset(-25)
            // FIXME: - 데이터 받으면
            $0.width.equalTo(100)
            $0.height.equalTo(140)
            //
            $0.centerX.equalTo(self.topView)
        }
        
        self.bottomStackView.snp.makeConstraints {
            $0.top.equalTo(self.bottomView).offset(15)
            $0.leading.equalTo(self.bottomView).offset(20)
            $0.trailing.equalTo(self.bottomView).offset(-20)
            $0.bottom.equalTo(self.bottomView).offset(-15)
        }
    }
}
