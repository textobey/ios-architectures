//
//  ViewController.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/13/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellable: [AnyCancellable] = []
    
    lazy var networkConfig: NetworkConfigurable = BookAPINetworkConfig(
        baseURL: URL(string: "https://api.itbook.store")!,
        headers: [:],
        queryParameters: [:]
    )
    
    lazy var networkSerivce: NetworkSerivce = DefaultNetworkSerivce(config: networkConfig)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endPoint = BookAPIEndPoint.fetchBooks()
        
        networkSerivce.request(endPoint: endPoint)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { data in
                // JSONDecoder().decode(BooksPage.self, from: data)
                print(data)
            })
            .store(in: &cancellable)
    }

}

