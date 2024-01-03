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
            ScrollView {
                LazyVStack(spacing: 20) {
                    // 트러블슈팅: NavigationLink에 의해 표시되는 arrrow symbol(icon)을 제거하는 방법이에요.
                        // 위의 이슈는 SwiftUI에서 제공하는 List를 사용할때 재현됨.
                        // LazyVStack/ForEach의 조합으로 직접 커스텀할때는 재현되지 않음.
                    ForEach(viewModel.books.indices, id: \.self) { index in
                        let bookItem = viewModel.books[index]
                        NavigationLink(
                            destination: {
                                BookDetailView(
                                    isbn13: bookItem.id ?? "",
                                    viewModel: BookDetailViewModel()
                                )
                            }, label: {
                                NewBookListRow(bookItem: bookItem)
                            }
                        )
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                // 1.
                // List의 Row가 onAppear 될때마다, 해당 아이템이 마지막인지를 체크하여
                // 마지막이라면 paging을 수행하는 방법
                
                // 2. < 채택
                // 자식 뷰를 먼저 로드하지 않는 LazyVStack에 ProgressView를 배치하여
                // ProgressView onAppear 시점에 paging을 수행하는 방법
                if !viewModel.books.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                            .onAppear {
                                self.viewModel.transform(.paging)
                            }
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("New Book")
        }
        .onAppear {
            self.viewModel.transform(.refresh)
        }
        // 트러블슈팅: StackNavigationViewStyle modifier를 추가하지 않으면 제약조건 오류 발생
        .navigationViewStyle(.stack)
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView(viewModel: NewBookViewModel())
    }
}
