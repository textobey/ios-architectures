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
            AsyncImage(url: URL(string: bookItem.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "book")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    ProgressView()
                }
            }
            .frame(width: 100, height: 130)
            .padding(.leading, 20)
            
            //Spacer()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(bookItem.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                
                Text(bookItem.subtitle ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                Text(bookItem.id ?? "")
                    .font(.system(size: 12, weight: .light))
                
                Text(bookItem.price ?? "")
                    .font(.system(size: 12, weight: .medium))
                
                Text(bookItem.url ?? "")
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                    .foregroundColor(Color.blue)
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
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
