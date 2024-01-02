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

@MainActor
class URLImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = true
    
    private var imageCache: NSCache<NSString, UIImage>?
    
    init(urlString: String?) {
        loadImage(urlString: urlString)
    }
    
    private func loadImage(urlString: String?) {
        guard let urlString = urlString else { return }
        
        isLoading = true
        
        if let imageFromCache = getImageFromCache(from: urlString) {
            self.image = imageFromCache
            isLoading = false
            return
        }
        loadImageFromURL(urlString: urlString)
    }
    
    /*
     MainActor 어트리뷰트를 지정하여 Task 블록의 작업을 메인스레드에서 수행하도록 자동으로 라우팅됨
     */
    
    private func loadImageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let loadedImage = UIImage(data: data) else {
                    print("❎ Failed Parse Data to Image ")
                    return
                }
                self.image = loadedImage
                self.setImageCache(image: loadedImage, key: urlString)
            } catch {
                print("❎ Failed \(#function) Error: \(error)")
            }
            self.isLoading = false
        }
    }
    
    private func setImageCache(image: UIImage, key: String) {
        imageCache?.setObject(image, forKey: key as NSString)
    }
    
    private func getImageFromCache(from key: String) -> UIImage? {
        return imageCache?.object(forKey: key as NSString) as? UIImage
    }
}
