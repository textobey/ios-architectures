//
//  NewBookView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI
import Combine

struct Ocean: Identifiable {
    let id = UUID()
    let name: String
}

struct NewBookView: View {
    @ObservedObject var viewModel: NewBookViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.books) { bookItem in
                    ZStack {
                        // 트러블슈팅: NavigationLink에 의해 표시되는 arrrow symbol(icon)을 제거하는 방법이에요.
                        NavigationLink(
                            destination: BookDetailView(
                                isbn13: bookItem.id ?? "",
                                viewModel: BookDetailViewModel()
                            )
                        ) {
                            EmptyView()
                        }
                        .opacity(0.0)
                        
                        NewBookListRow(bookItem: bookItem)
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .navigationTitle("New Book")
        }
        .onAppear {
            self.viewModel.transform(.refresh)
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView(viewModel: NewBookViewModel())
    }
}
