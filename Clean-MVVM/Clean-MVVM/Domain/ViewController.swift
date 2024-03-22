//
//  ViewController.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let bookDIContainer: BookDIContainer
    
    var cancellable: Set<AnyCancellable> = []
    
    init(bookDIContainer: BookDIContainer) {
        self.bookDIContainer = bookDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookDIContainer.fetchNewBookUseCase.execute()
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

