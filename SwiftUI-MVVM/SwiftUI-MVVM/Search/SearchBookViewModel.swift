//
//  SearchBookViewModel.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 1/3/24.
//

import SwiftUI
import Combine

class SearchBookViewModel: ObservableObject, UnidirectionalDataFlowType {
    typealias InputType = Input
    
    private var cancellables: [AnyCancellable] = []
    
    private let searchSubject = PassthroughSubject<String, Never>()
    
    @Published private(set) var bookItems: [BookItem] = []
    
    private let responseSubject = PassthroughSubject<BookModel, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    func transform(_ input: InputType) {
        switch input {
        case .search(let word):
            searchSubject.send(word)
        case .paging:
            print("paging")
        }
    }
    
    enum Input {
        case search(String)
        case paging
    }
    
    private let network: BookNetworkingType
    
    init(network: BookNetworkingType = BookNetworking()) {
        self.network = network
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        searchSubject
            .flatMap { word in
                self.requestSearchBookAPI(of: word)
            }
            .subscribe(responseSubject)
            .store(in: &cancellables)
    }
    
    private func bindOutputs() {
        responseSubject
            .map { $0.books ?? [] }
            .assign(to: \.bookItems, on: self)
            .store(in: &cancellables)
    }
}

extension SearchBookViewModel {
    private func requestSearchBookAPI(of word: String, page: String = "1") -> AnyPublisher<BookModel, Never> {
        return network.request(.search(word, page))
            .catch { error in
                print("❎ SearchBookViewModel \(#line) Error: \(error)")
                self.errorSubject.send(error)
                return Empty<BookModel, Never>()
            }
            .eraseToAnyPublisher()
    }
}
