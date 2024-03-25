//
//  NewBookTableViewCell.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import UIKit
import Then
import SnapKit

class NewBookTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: NewBookTableViewCell.self)
    
    let wrapperView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    let topView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    let bottomView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    let topImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let bookmarkIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.setImage(UIImage(systemName: "star.fill"), for: .selected)
        $0.tintColor = .black.withAlphaComponent(0.6)
    }
    
    let bottomStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }

    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    let isbn13Label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }
    
    let priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        wrapperView.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        wrapperView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        topView.addSubview(topImageView)
        topImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-25)
            $0.width.equalTo(100)
            $0.height.equalTo(140)
            $0.centerX.equalToSuperview()
        }
        
        topView.addSubview(bookmarkIcon)
        bookmarkIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(22)
            $0.height.equalTo(20)
        }
        
        bottomView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        [titleLabel, subtitleLabel, isbn13Label, priceLabel].forEach {
            bottomStackView.addArrangedSubview($0)
        }
    }
    
    func configure(book: Book) {
        titleLabel.text = book.title ?? ""
        subtitleLabel.text = book.subtitle ?? ""
        priceLabel.text = book.price ?? ""
        isbn13Label.text = book.isbn13 ?? ""
        //TODO: Image load 모듈 개발
        //topImageView.kf.setImage(with: URL(string: bookModel?.image ?? ""))
        bookmarkIcon.isSelected = false
    }
}

