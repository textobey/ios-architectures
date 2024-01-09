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
    
    @State var searchText: String = ""
    
    public init(viewModel: SearchBookViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.bookItems.indices, id: \.self) { index in
                        let bookItem = viewModel.bookItems[index]
                        NavigationLink(
                            destination: {
                                BookDetailView(
                                    isbn13: bookItem.id ?? "",
                                    viewModel: BookDetailViewModel()
                                )
                            }, label: {
                                SearchBookRow(bookItem: bookItem)
                            }
                        )
                        .buttonStyle(.plain)
                    }
                    
                    if !viewModel.bookItems.isEmpty, viewModel.isPagable {
                        HStack {
                            Spacer()
                            ProgressView()
                                .onAppear {
                                    viewModel.transform(.paging(searchText))
                                }
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Search Book")
            .searchable(
                text: $searchText,
                // navigationBarDrawer: 검색창이 숨겨져있고, 네비게이션을 밑으로 내렸을때만 검색창이 표출
                // navigationBarDrawer(displayMode: .always): 검색창이 숨겨져 있지 않고, 항상 표출
                // automatic: iOS, iPad OS 각 플랫폼 마다 다르게 적용(iOS는 navigationBarDrawer)
                // sideBar: sidebar에서 적용되는 검색창
                // toolbar: toolbar에서 적용되는 검색창
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search"
            )
            .onSubmit(of: .search) {
                viewModel.transform(.search(searchText))
            }
            .onChange(of: searchText) { newValue in
                viewModel.transform(.search(newValue))
            }
            //iOS16부터는 .scrollDismissesKeyboard()로 간단하게 처리 가능
            .scrollDismissesKeyboard(.immediately)
            //.resignKeyboardOnDragGesture()
        }
        // 트러블슈팅: StackNavigationViewStyle modifier를 추가하지 않으면 제약조건 오류 발생
        .navigationViewStyle(.stack)
        .overlay {
            if viewModel.bookItems.isEmpty && searchText.isEmpty {
                ContentEmptyView(message: .constant(""))
            } else if viewModel.bookItems.isEmpty {
                ContentEmptyView(message: $searchText)
            }
        }
    }
}

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookView(viewModel: SearchBookViewModel())
    }
}
