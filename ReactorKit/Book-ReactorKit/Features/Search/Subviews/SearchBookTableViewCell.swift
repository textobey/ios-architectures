//
//  SearchBookTableViewCell.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/06.
//

import UIKit
import SnapKit

class SearchBookTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: SearchBookTableViewCell.self)
    
    // MARK: - stored properties
    lazy var wrapperView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var bookImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var stackView = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = nil
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = nil
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .light)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = nil
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.text = nil
    }
    
    lazy var urlLinkLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .systemBlue
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
            $0.directionalEdges.equalToSuperview()
        }
        
        wrapperView.addSubview(bookImage)
        bookImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 100, height: 130))
        }
        
        wrapperView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(bookImage)
            $0.leading.equalTo(bookImage.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        [titleLabel, subtitleLabel, isbn13Label, priceLabel, urlLinkLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}

extension SearchBookTableViewCell {
    func bindView(bookItem: BookItem?) {
        self.titleLabel.text = bookItem?.title ?? ""
        self.subtitleLabel.text = bookItem?.subtitle ?? ""
        self.isbn13Label.text = bookItem?.isbn13 ?? ""
        self.priceLabel.text = bookItem?.price ?? ""
        self.urlLinkLabel.text = bookItem?.url ?? ""
        self.bookImage.kf.setImage(with: URL(string: bookItem?.image ?? ""))
    }
}
