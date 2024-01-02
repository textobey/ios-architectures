//
//  AsyncImageView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/18/23.
//

import SwiftUI

struct AsyncImageView: View {
    @ObservedObject private var imageLoader: URLImageLoader
    
    init(urlString: String?) {
        self.imageLoader = URLImageLoader(urlString: urlString)
    }
    
    var body: some View {
        Group {
            if imageLoader.isLoading {
                ProgressView()
            } else {
                Image(uiImage: imageLoader.image ?? UIImage())
                    .resizable()
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(urlString: "https://developer.apple.com/news/images/og/swiftui-og.png")
    }
}
