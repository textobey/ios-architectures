//
//  ViewController.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellable: Set<AnyCancellable> = []
    
    lazy var fetchNewBookUseCase: FetchNewBooksUseCase = DefaultFetchNewBooksUseCase(
        bookRepository: DefaultBookRepository(
            dataTransferSerivce: DefaultDataTransferService(
                networkSerivce: DefaultNetworkSerivce(
                    config: BookAPINetworkConfig(
                        baseURL: URL(string: "https://api.itbook.store")!,
                        headers: [:],
                        queryParameters: [:]
                    )
                )
            )
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNewBookUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print("⚠️ error: \(failure.localizedDescription)")
                }
            }, receiveValue: { response in
                print(response)
            })
            .store(in: &cancellable)
    }

}

