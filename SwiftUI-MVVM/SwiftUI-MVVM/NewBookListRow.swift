//
//  NewBookListRow.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct NewBookListRow: View {
    
    @State var bookItem: BookItem
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 140)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
            }
            .frame(maxWidth: .infinity, idealHeight: 190)
            .background(Color(.systemGray6))
            
            VStack {
                Text(bookItem.title ?? "")
                
                Text(bookItem.subtitle ?? "")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(Color(.systemGray5))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct NewBookListRow_Previews: PreviewProvider {
    static var previews: some View {
        NewBookListRow(
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
