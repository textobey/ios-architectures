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
    private let inputPassthroughSubject = PassthroughSubject<NewBookViewModel.ActionType, Never>()
    
    init(viewModel: NewBookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
        inputPassthroughSubject.send(.fetchNewBooks)
    }
    
    private func setupLayout() {
        
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: inputPassthroughSubject.eraseToAnyPublisher())
        
        output
            .sink(receiveValue: { [weak self] state in
                self?.handleStateUpdate(state)
            })
            .store(in: &cancellable)
    }
    
    private func handleStateUpdate(_ state: NewBookViewModel.State) {
        switch state {
        case .newBooks(let books):
            print(books)
            
        case .none:
            return
        }
    }
}
