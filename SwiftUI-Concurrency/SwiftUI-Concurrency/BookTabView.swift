//
//  BookTabView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import SwiftUI

struct BookTabView: View {
    
    let networking: BookNetworking = DefaultBookNetworking()
    
    var body: some View {
        TabView {
            NewBookView(networking: networking)
                .tabItem {
                    Image(systemName: "book")
                    Text("New")
                }
            
            SearchBookView(networking: networking)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .preferredColorScheme(.light)
        .font(.headline)
        .onAppear {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
