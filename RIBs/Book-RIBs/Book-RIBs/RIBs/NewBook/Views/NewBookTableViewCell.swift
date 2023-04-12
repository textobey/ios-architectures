//
//  NewBookTableViewCell.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
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
        return newBookContentView.bookmarkIcon.rx.tap.asObservable()
            .map { [weak self] _ -> Bool in
                self?.newBookContentView.bookmarkIcon.isSelected ?? false
            }
    }
    
    lazy var newBookContentView = NewBookContentView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - initialze method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError(#function)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - set up view
extension NewBookTableViewCell {
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(newBookContentView)
        newBookContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - methods
extension NewBookTableViewCell {
    // cell 을 구성하는 함수
    func configureCell(by bookModel: BookItem?) {
        newBookContentView.titleLabel.text = bookModel?.title ?? ""
        newBookContentView.subtitleLabel.text = bookModel?.subtitle ?? ""
        newBookContentView.priceLabel.text = bookModel?.price ?? ""
        newBookContentView.isbn13Label.text = bookModel?.isbn13 ?? ""
        newBookContentView.topImageView.kf.setImage(with: URL(string: bookModel?.image ?? ""))
        newBookContentView.bookmarkIcon.isSelected = bookModel?.isBookmarked() ?? false
    }
}
