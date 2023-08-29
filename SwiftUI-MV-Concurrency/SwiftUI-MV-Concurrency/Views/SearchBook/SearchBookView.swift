//
//  SearchBookView.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import SwiftUI

struct SearchBookView: View {
    
    let networking: BookNetworking
    
    @State var bookModel: BookModel?
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(bookModel?.books ?? [], id: \.id) { book in
                        ZStack {
                            SearchBookListRow(bookItem: book)
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Search Books")
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            
        }
        .onReceive(searchText.publisher.first()) { _ in
            requestSearchBooksAPI(of: searchText)
        }
    }
    
    func requestSearchBooksAPI(of text: String) {
        Task {
            let bookModel: BookModel = try await networking.request(.search(searchText, 0))
            self.bookModel = bookModel
        }
    }
}
