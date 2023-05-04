//
//  RootTabView.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/04.
//

import SwiftUI

struct RootTabView: View {
    
    typealias TabBarItem = RootTabView.TabViewItemModel
    
    private var tabBarItems: [TabBarItem] {
        return self.fetchTabViewItems()
    }
    
    var body: some View {
        TabView {
            ForEach(Array(zip(createViews(), tabBarItems)), id: \.1) { view, tabBarItem in
                view.tabItem {
                    Label(tabBarItem.title, systemImage: tabBarItem.imageName)
                }
            }
        }
    }
}

extension RootTabView {
    
    struct TabViewItemModel: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let imageName: String
    }
    
    private func createViews() -> [AnyView] {
        return [
            AnyView(NewBookView()),
            AnyView(SearchBookView())
        ]
    }
    
    private func setupTabView() {
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor.systemGroupedBackground
    }
    
    private func fetchTabViewItems() -> [TabViewItemModel] {
        return [
            TabViewItemModel(title: "New", imageName: "book"),
            TabViewItemModel(title: "Search", imageName: "magnifyingglass")
        ]
    }
    
    private func fetchNavigationBarTitles() -> [String] {
        return ["New Books", "Search Books"]
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
