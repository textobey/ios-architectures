//
//  SearchBookRow.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 1/4/24.
//

import SwiftUI
import Combine

struct SearchBookRow: View {
    
    @State var bookItem: BookItem
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: bookItem.url ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "book")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    ProgressView()
                }
            }
            .frame(width: 100, height: 130)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            Spacer()
            
            VStack {
                Text("제목")
                
                Text("서브타이틀")
            }
        }
        .frame(maxWidth: .infinity, idealHeight: 150)
    }
}

struct SearchBookRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookRow(
            bookItem: BookItem(
                id: "9781803242002",
                title: "Test-Driven Development with Swift",
                subtitle: "A simple guide to writing bug-free Agile code",
                price: "$44.99",
                image: "https://itbook.store/img/books/9781803242002.png",
                url: "https://itbook.store/books/9781803242002"
            )
        )
    }
}
