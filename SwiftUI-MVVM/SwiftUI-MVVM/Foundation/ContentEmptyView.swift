//
//  ContentEmptyView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 1/4/24.
//

import SwiftUI

/// iOS 17 이상에서는 Swift API인 ContentUnavailableView를 사용하여 대체 가능
struct ContentEmptyView: View {
    
    @State var message: String
    
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Text("Check the spelling or try a new search.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}

struct ContentEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ContentEmptyView(message: "No Results")
    }
}
