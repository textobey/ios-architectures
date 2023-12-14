//
//  ContentView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewBookView(viewModel: NewBookViewModel())
                .tabItem {
                    Label("NewBook", systemImage: "book")
                }
            
            SearchBookView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
