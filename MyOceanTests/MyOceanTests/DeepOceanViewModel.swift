//
//  DeepOceanViewModel.swift
//  MyOceanTests
//
//  Created by 이서준 on 1/29/24.
//

import UIKit

class DeepOceanViewModel {
    @Published var uiImage: UIImage?
    @Published var error: Error?
    
    private let networkService: AnyNetworkService
    
    init(networkService: AnyNetworkService) {
        self.networkService = networkService
    }
    
    func downloadWallPaper() {
        networkService.looooogNetworkCall { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.uiImage = success
                }
            case .failure(let failure):
                self.error = failure
            }
        }
    }
    
    func sum(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
}
