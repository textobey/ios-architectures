//
//  BookDetailViewModel.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 2023/12/15.
//

import SwiftUI
import Combine

final class BookDetailViewModel: ObservableObject, UnidirectionalDataFlowType {
    typealias InputType = Input
    
    private var cancellables: [AnyCancellable] = []
    
    private let loadBookSubject = PassthroughSubject<String, Never>()
    
    @Published private(set) var bookItem: BookModel?
    
    private let responseSubject = PassthroughSubject<BookModel, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    enum Input {
        case load(String)
    }
    
    func transform(_ input: Input) {
        switch input {
        case .load(let isbn13):
            loadBookSubject.send(isbn13)
        }
    }
    
    private let network: BookNetworkingType
    
    init(network: BookNetworkingType = BookNetworking()) {
        self.network = network
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        loadBookSubject
            .flatMap { [weak self] isbn13 -> AnyPublisher<BookModel, Never> in
                self?.network.request(.detail(isbn13))
                    .catch { error in
                        print("❎ BookDetailViewModel \(#line) Error: \(error)")
                        self?.errorSubject.send(error)
                        return Empty<BookModel, Never>()
                    }
                    .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
            }
            .delay(for: 1, scheduler: DispatchQueue.main)
            .share()
            .subscribe(responseSubject)
            .store(in: &cancellables)
    }
    
    private func bindOutputs() {
        responseSubject
            .compactMap { $0 }
            .assign(to: \.bookItem, on: self)
            .store(in: &cancellables)
    }
}
