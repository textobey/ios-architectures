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
    
    @Published var jokeList: [String] = []
    
    let debouncer = Debouncer(timeInterval: 0.3)
    
    let networkService: AnyNetworkService
    let cloudService: AnyService
    
    var measureCount: Int = 0
    
    init(networkService: AnyNetworkService, cloudService: AnyService) {
        self.networkService = networkService
        self.cloudService = cloudService
        self.getJokeList()
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
    
    func getJokeList() {
        jokeList = networkService.fetchJokeList()
    }
    
    func callSomeAsyncOperation() {
        cloudService.someAsyncOperation()
    }
    
    func anotherAsyncOperation(completionHandler: @escaping () -> Void) {
        cloudService.anotherAsyncOperation(completionHandler: completionHandler)
    }
    
    func searchWithDebouncer(_ value: String, completionHandler: @escaping () -> Void) {
        debouncer.renewInterval()
        
        debouncer.handler = {
            print("try Search: \(value)")
            completionHandler()
        }
    }
    
    func callAsyncAwaitCloudSerivce() async throws -> UIImage? {
        return UIImage(data: try await cloudService.asyncAwaitCall())
    }
    
    func heavyCalculration() {
        (0 ..< 2_000_000).forEach { _ in
            measureCount += 1
        }
    }
    
    func sum(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
}
