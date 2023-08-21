//
//  SearchBookView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import SwiftUI

struct SearchBookView: View {
    
    let networking: BookNetworking
    
    @State var bookModel: BookModel?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookModel?.books ?? [], id: \.id) { book in
                    ZStack {
                        SearchBookListRow(bookItem: book)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .listRowSeparator(.hidden)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .navigationTitle("Search Books")
        }
        .onAppear {
            Task {
                let books = try await networking.searchBook(at: "Apple", page: 1)
                await MainActor.run {
                    self.bookModel = books
                }
            }
        }
    }
}
