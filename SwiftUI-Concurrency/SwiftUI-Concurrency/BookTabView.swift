//
//  BookTabView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import SwiftUI

struct BookTabView: View {
    var body: some View {
        TabView {
            NewBookView()
                .tabItem {
                    Image(systemName: "book")
                    Text("New")
                }
            
            SearchBookView()
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
