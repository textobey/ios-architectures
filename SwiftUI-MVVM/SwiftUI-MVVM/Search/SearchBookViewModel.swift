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
    
    private let searchSubject = PassthroughSubject<(String, String), Never>()
    
    @Published private(set) var bookItems: [BookItem] = []
    @Published private(set) var isPagable: Bool = true
    
    private let responseSubject = CurrentValueSubject<BookModel?, Never>(nil)
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private enum Const {
        static let defaultPage: String = "1"
    }
    
    func transform(_ input: InputType) {
        switch input {
        case .search(let word):
            bookItems = []
            searchSubject.send((word, Const.defaultPage))
        case .paging(let word):
            guard isValidPaging() else { return }
            let nextPage = getNextPage()
            searchSubject.send((word, nextPage))
        }
    }
    
    enum Input {
        case search(String)
        case paging(String)
    }
    
    private let network: BookNetworkingType
    
    init(network: BookNetworkingType = BookNetworking()) {
        self.network = network
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        searchSubject
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
            .flatMap { word, page in
                self.requestSearchBookAPI(of: word, page: page)
            }
            .compactMap { $0 }
            .subscribe(responseSubject)
            .store(in: &cancellables)
    }
    
    private func bindOutputs() {
        responseSubject
            .compactMap {
                let newBookItems = self.bookItems + ($0?.books ?? [])
                self.isPagable = newBookItems.count < Int($0?.total ?? "0") ?? 0
                return newBookItems
            }
            .assign(to: \.bookItems, on: self)
            .store(in: &cancellables)
    }
}

extension SearchBookViewModel {
    private func requestSearchBookAPI(of word: String, page: String = Const.defaultPage) -> AnyPublisher<BookModel, Never> {
        return network.request(.search(word, page))
            .catch { error in
                print("❎ SearchBookViewModel \(#line) Error: \(error)")
                self.errorSubject.send(error)
                return Empty<BookModel, Never>()
            }
            .eraseToAnyPublisher()
    }
}

extension SearchBookViewModel {
    private func isValidPaging() -> Bool {
        guard let stringTotal = responseSubject.value?.total, let total = Int(stringTotal) else {
            return false
        }
        return bookItems.count < total
    }
    
    private func getNextPage() -> String {
        let currentPage = responseSubject.value?.page ?? Const.defaultPage
        
        if let intCurrentPage = Int(currentPage) {
            return String(intCurrentPage + 1)
        } else {
            return currentPage
        }
    }
}
