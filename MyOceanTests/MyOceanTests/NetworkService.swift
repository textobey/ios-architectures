//
//  NetworkService.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/16/24.
//

import UIKit

protocol AnyNetworkService {
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ())
}

class NetworkService: AnyNetworkService {
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ()) {
        sleep(5)

        let request = URLRequest(url: URL(string: "https://unsplash.com/photos/XVoyX7l9ocY/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8OHx8c2NvdGxhbmR8ZW58MHx8fHwxNjk3NTA5MTQ4fDA&force=true&w=640")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completionHandler(.success(image))
            } else if let error {
                completionHandler(.failure(error))
            }
        }
        
        task.resume()
    }
}
