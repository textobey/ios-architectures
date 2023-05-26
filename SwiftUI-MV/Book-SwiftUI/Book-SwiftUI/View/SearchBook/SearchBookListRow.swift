//
//  SearchBookListRow.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/26.
//

import SwiftUI
import Kingfisher

struct SearchBookListRow: View {
    
    var bookItem: BookItem?
    
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            KFImage(URL(string: bookItem?.image ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 130)
                .clipped()
                //.background(Color.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(bookItem?.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    
                Text(bookItem?.subtitle ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                    
                Text(bookItem?.id ?? "")
                    .font(.system(size: 12, weight: .light))
                    .lineLimit(1)
                    
                Text(bookItem?.price ?? "")
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                    
                Text(bookItem?.url ?? "")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            //.background(Color.green)
        }
        .padding(.horizontal, 20)
        //.background(Color.red)
        .padding(.vertical, 10)
    }
}

struct SearchBookListRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookListRow(
            bookItem: BookItem(
                id: "isbn13",
                title: "title",
                subtitle: "subtitle",
                price: "price",
                image: "https://itbook.store/img/books/9781098116743.png",
                url: ""
            )
        )
    }
}

