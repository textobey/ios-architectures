//
//  NetworkService.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/16/24.
//

import UIKit

protocol AnyNetworkService {
    func looooogNetworkCall(_ completionHandler: @escaping (Result<UIImage, Error>) -> ())
    func fetchJokeList() -> [String]
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
    
    // 실제로는 진짜 네트워킹 요청을하는 메서드라고 생각해봐요
    func fetchJokeList() -> [String] {
        let list = [
            "When your code refuses to work, just blame it on cosmic rays!",
            "Debugging is like being the detective in a crime movie where you're also the murderer.",
            "Real programmers count from 0. Or at least until they hit 1.",
            "Why do programmers always mix up Christmas and Halloween? Because Oct 31 == Dec 25.",
            "Why do programmers prefer iOS development? Because it's the only place where an 'apple' a day keeps the bugs away!",
            "The best code is the one you don't have to write. Also, it's the one you don't have to test!",
            "Why did the programmer go broke? Because he used up all his cache!",
            "I asked the computer for a joke, and it replied, 'Why don't programmers like nature? It has too many bugs.'",
            "Programming is 10% writing code and 90% figuring out why that code doesn't work.",
            "You know you're a programmer when you spend more time Googling error messages than writing code."
        ]
        
        return list
    }
}
