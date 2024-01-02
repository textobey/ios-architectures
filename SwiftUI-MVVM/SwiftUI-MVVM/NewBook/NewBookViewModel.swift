//
//  NewBookViewModel.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/14/23.
//

import SwiftUI
import Combine

final class NewBookViewModel: ObservableObject, UnidirectionalDataFlowType {
    typealias InputType = Input
    
    private var cancellables: [AnyCancellable] = []
    
    private let refreshSubject = PassthroughSubject<Void, Never>()
    private let pagingSubject = PassthroughSubject<Void, Never>()
    
    @Published private(set) var books: [BookItem] = []
    
    private let responseSubject = PassthroughSubject<BookModel, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    enum Input {
        case refresh
        case paging
    }
    
    func transform(_ input: Input) {
        switch input {
        case .refresh:
            refreshSubject.send(())
        case .paging:
            print("✅ Itbooks New API Paging Parameter 지원하지 않음")
        }
    }
    
    private let network: BookNetworkingType
    
    init(network: BookNetworkingType = BookNetworking()) {
        self.network = network
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        // multicast: 미사용시: 여러 구독자에게 건by건으로 emit 하지만, 사용하면 한번의 emit으로 모두 받아볼수있다. .connect()를 호출해야 요소를 방출함
        // share: 업스트림의 게시자의 출력을 여러 구독자와 공유. multicast와 비슷하게 하나의 emit으로 모든 구독자들에게 요소를 방출할수 있다.
        
        let responseStream = refreshSubject
            .flatMap { [weak self] _ -> AnyPublisher<BookModel, Never> in
                self?.network.request(.new)
                    .catch { error in
                        print("❎ NewBookViewModel \(#line) Error: \(error)")
                        self?.errorSubject.send(error)
                        return Empty<BookModel, Never>()
                    }
                    .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
            }
            .delay(for: 1, scheduler: DispatchQueue.main)
            .share()
            .subscribe(responseSubject)
        
        cancellables += [
            responseStream
        ]
    }
    
    private func bindOutputs() {
        let booksStream = responseSubject
            .map { $0.books ?? [] }
            .assign(to: \.books, on: self)
        
        cancellables += [
            booksStream
        ]
    }
}
