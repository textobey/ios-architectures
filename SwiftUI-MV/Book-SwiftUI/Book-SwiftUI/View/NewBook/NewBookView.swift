//
//  NewBookView.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/04.
//

import SwiftUI
import Kingfisher

struct NewBookView: View {
    
    // MARK: - Properties
    
    //@State private var isBookmarked = false
    //@ObservedObject var bookModel: BookModel = BookModel()
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
            NetworkService.shared.request(.new, completion: { result in
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

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
