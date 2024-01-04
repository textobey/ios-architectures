//
//  SearchBookView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI
import Combine

struct SearchBookView: View {
    @ObservedObject var viewModel: SearchBookViewModel
    
    @State var text: String = ""
    @State var scopeSelection: Int = 0
    
    public init(viewModel: SearchBookViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.bookItems.indices, id: \.self) { index in
                        let bookItem = viewModel.bookItems[index]
                        SearchBookRow(bookItem: bookItem)
                    }
                }
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
        // 트러블슈팅: StackNavigationViewStyle modifier를 추가하지 않으면 제약조건 오류 발생
        .navigationViewStyle(.stack)
        .overlay {
            if viewModel.bookItems.isEmpty {
                ContentEmptyView(message: "No Articles for \(text)")
            }
        }
    }
}

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView(viewModel: SearchBookViewModel())
    }
}
