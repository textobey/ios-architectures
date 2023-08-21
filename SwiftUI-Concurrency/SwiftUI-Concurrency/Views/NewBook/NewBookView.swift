//
//  NewBookView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import SwiftUI

struct NewBookView: View {
    
    let networking: BookNetworking
    
    @State var bookModel: BookModel?
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(bookModel?.books ?? [], id: \.id) { book in
                        ZStack {
                            NewBookListRow(bookItem: book)
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .listRowSeparator(.hidden)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("New Book", displayMode: .large)
        }
        .onAppear {
            Task {
                let books = try await networking.fetchNewBooks()
                await MainActor.run {
                    self.bookModel = books
                }
            }
        }
    }
}
