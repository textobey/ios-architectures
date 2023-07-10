//
//  ApodTabView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/10.
//

import SwiftUI

struct ApodTabView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "globe.europe.africa")
                    Text("Browse")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
            
            FormView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("FeedBack")
                }
        }
        .preferredColorScheme(.dark)
        .font(.headline)
        .onAppear {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
