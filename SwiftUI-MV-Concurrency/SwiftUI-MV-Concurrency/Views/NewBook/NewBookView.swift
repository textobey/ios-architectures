//
//  NewBookView.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
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

                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("New Book", displayMode: .large)
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            requestNetBooksAPI()
        }
    }
    
    func requestNetBooksAPI() {
        Task {
            let bookModel: BookModel = try await networking.request(.book)
            self.bookModel = bookModel
        }
        
    }
}
