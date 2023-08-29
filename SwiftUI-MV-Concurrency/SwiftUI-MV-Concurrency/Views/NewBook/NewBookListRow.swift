//
//  NewBookListRow.swift
//  SwiftUI-MV-Concurrency
//
//  Created by 이서준 on 2023/08/29.
//

import SwiftUI
import Kingfisher

struct NewBookListRow: View {
    
    @State private var isBookmarked = false
    
    var bookItem: BookItem?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                KFImage(URL(string: bookItem?.image ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 140)
                
                HStack {
                    Spacer()

                    VStack {
                        Button(action: {
                            isBookmarked.toggle()
                        }, label: {
                            Image(systemName: isBookmarked ? "star.fill" : "star")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(Color.black.opacity(0.6))
                        })
                        .buttonStyle(.plain)
                        .frame(width: 22, height: 20)

                        Spacer()
                    }
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
                
            }
            .frame(maxWidth: .infinity, idealHeight: 190)
            .background(Color(.systemGray6))
            
            
            VStack(spacing: 5) {
                Text(bookItem?.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                
                Text(bookItem?.subtitle ?? "")
                    .font(.system(size: 14, weight: .medium))
                
                Text(bookItem?.id ?? "")
                    .font(.system(size: 12, weight: .light))
                
                Text(bookItem?.price ?? "")
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(Color(.systemGray5))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.top, 10)
        .padding(.bottom, 10)
        
    }
}

struct NewBookListRow_Previews: PreviewProvider {
    static var previews: some View {
        NewBookListRow(
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
