//
//  NewBookViewController.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/25/24.
//

import UIKit
import Combine
import Then
import SnapKit

class NewBookViewController: UIViewController {
    
    // MARK: Important
    
    private let viewModel: NewBookViewModel
    
    private var cancellable: Set<AnyCancellable> = []
    private let inputPassthroughSubject = PassthroughSubject<NewBookViewModel.ActionType, Never>()
    
    // MARK: Properties
    
    private var dataSource: [Book] = []
    
    // MARK: UI Components
    
    lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(NewBookTableViewCell.self, forCellReuseIdentifier: NewBookTableViewCell.identifier)
    }
    
    // MARK: Init
    
    init(viewModel: NewBookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        bindViewModel()
        inputPassthroughSubject.send(.fetchNewBooks)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: inputPassthroughSubject.eraseToAnyPublisher())
        
        output
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                self?.handleStateUpdate(state)
            })
            .store(in: &cancellable)
    }
    
    private func handleStateUpdate(_ state: NewBookViewModel.State) {
        switch state {
        case .newBooks(let books):
            dataSource = books
            tableView.reloadData()
            
        case .none:
            return
        }
    }
}

//TODO: Delegate -> Combine(Reactive) Binding
extension NewBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NewBookTableViewCell.identifier,
            for: indexPath
        ) as? NewBookTableViewCell {
            cell.configure(book: dataSource[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}
