//
//  SearchBookView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct SearchBookView: View {
    
    @State var text: String = ""
    @State var scopeSelection: Int = 0
    
    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "India"),
        Ocean(name: "Southern"),
        Ocean(name: "East Sea"),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                List(oceans) { _ in
                    ZStack {
                        NavigationLink(
                            destination: BookDetailView()
                        ) {
                            //NewBookListRow(bookItem: bookItem)
                        }
                        .opacity(0.0)
                        
                        //NewBookListRow(bookItem: bookItem)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listRowInsets(EdgeInsets())
                .listStyle(.plain)
            }
            .navigationTitle("Search Book")
            .navigationSearchBar(
                text: $text,
                scopeSelection: $scopeSelection,
                options: [
                    .automaticallyShowsSearchBar: true,
                    .obscuresBackgroundDuringPresentation: false,
                    .hidesNavigationBarDuringPresentation: true,
                    .hidesSearchBarWhenScrolling: false,
                    .placeholder: "Search",
                ],
                actions: [
                    .onCancelButtonClicked: {
                        print("Cancel")
                    },
                    .onSearchButtonClicked: {
                        print("Search")
                    }
                ]
            )
        }
    }
}

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView()
    }
}
