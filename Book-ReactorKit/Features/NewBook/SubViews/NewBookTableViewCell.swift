//
//  NewBookTableViewCell.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import SnapKit

class NewBookTableViewCell: UITableViewCell {
    // MARK: - stored properties
    static let identifier = String(describing: NewBookTableViewCell.self)
    
    lazy var contentsView = NewBookContentView()
    
    // MARK: - initialze method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.contentsView)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError(#function)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentsView.titleLabel.text = nil
        self.contentsView.subtitleLabel.text = nil
        self.contentsView.priceLabel.text = nil
        self.contentsView.isbn13Label.text = nil
        self.contentsView.topImageView.image = nil
    }
}

// MARK: - set up view
extension NewBookTableViewCell {
    func setupView() {
        self.contentsView.snp.makeConstraints {
            $0.top.bottom.equalTo(super.contentView).inset(10)
            $0.leading.trailing.equalTo(super.contentView).inset(20)
        }
    }
}

// MARK: - methods
extension NewBookTableViewCell {
    // cell 을 구성하는 함수
    func configureCell(by bookModel: BookItem?) {
        self.contentsView.titleLabel.text = bookModel?.title ?? ""
        self.contentsView.subtitleLabel.text = bookModel?.subtitle ?? ""
        self.contentsView.priceLabel.text = bookModel?.price ?? ""
        self.contentsView.isbn13Label.text = bookModel?.isbn13 ?? ""

        DispatchQueue.main.async {
            guard let urlString = bookModel?.image else { return }
            guard let imageURL = URL(string: urlString) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            self.contentsView.topImageView.image = UIImage(data: imageData)
        }
    }
}
