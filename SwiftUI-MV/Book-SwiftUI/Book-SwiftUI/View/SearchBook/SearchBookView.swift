//
//  SearchBookView.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/04.
//

import SwiftUI

struct SearchBookView: View {
    
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
            NetworkService.shared.request(.search(word: "Apple", page: 1), completion: { result in
                switch result {
                case .success(let bookModel):
                    DispatchQueue.main.async {
                        print(bookModel)
                        self.bookModel = bookModel
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView()
    }
}
