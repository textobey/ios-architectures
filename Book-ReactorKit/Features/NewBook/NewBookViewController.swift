//
//  NewBookViewController.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import UIKit

class NewBookViewController: UIViewController {
    
    private let newBookView = NewBookView()

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
