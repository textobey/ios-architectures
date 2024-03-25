//
//  NewBookViewController.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import UIKit
import Combine

class NewBookViewController: UIViewController {
    
    private let viewModel: NewBookViewModel
    
    private var cancellable: Set<AnyCancellable> = []
    
    init(viewModel: NewBookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
}
