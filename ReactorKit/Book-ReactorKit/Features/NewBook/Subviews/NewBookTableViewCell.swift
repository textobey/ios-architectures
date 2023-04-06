//
//  NewBookTableViewCell.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class NewBookTableViewCell: UITableViewCell {
    // MARK: - stored properties
    static let identifier = String(describing: NewBookTableViewCell.self)
    
    var disposeBag = DisposeBag()
    
    var bookmarkTap: Observable<Bool> {
        return self.contentsView.bookmarkIcon.rx.tap.asObservable()
            .map { [weak self] _ -> Bool in
                self?.contentsView.bookmarkIcon.isSelected ?? false
            }
    }
    
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
        disposeBag = DisposeBag()
        self.contentsView.titleLabel.text = nil
        self.contentsView.subtitleLabel.text = nil
        self.contentsView.priceLabel.text = nil
        self.contentsView.isbn13Label.text = nil
        self.contentsView.topImageView.image = nil
        self.contentsView.bookmarkIcon.isSelected = false
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
        self.contentsView.topImageView.kf.setImage(with: URL(string: bookModel?.image ?? ""))
        self.contentsView.bookmarkIcon.isSelected = bookModel?.isBookmarked() ?? false
    }
}
