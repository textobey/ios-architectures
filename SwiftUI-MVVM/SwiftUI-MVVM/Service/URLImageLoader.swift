//
//  URLImageLoader.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/18/23.
//

import SwiftUI

/*
 iOS 15+에서는 AsyncImage를 통해서, url을 통해 Image UI를 표시하는것이 매우 쉬워졌지만
 그 미만 버전에서는 URLSession을 통해 데이터를 받아와 이미지로 변환해야해요.
 */

class URLImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var imageCache: NSCache<NSString, UIImage>?
    
    init(urlString: String?) {
        loadImage(urlString: urlString)
    }
    
    private func loadImage(urlString: String?) {
        guard let urlString = urlString else { return }
        Task {
            await loadImageFromURL(urlString: urlString)
        }
    }
    
    private func loadImageFromURL(urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let loadedImage = UIImage(data: data) else {
                print("❎ Failed Parse Data to Image ")
                return
            }
            self.image = loadedImage
        } catch {
            print("❎ Failed \(#function) Error: \(error)")
        }
    }
}
