
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
                AsyncImage(url: URL(string: bookItem.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "book")
                            .resizable()
                            .scaledToFill()
                    //case .empty:
                        // 이미지를 로드하기 이전의 상태
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 170)
            }
            .padding(.top, 25)
            .padding(.bottom, 25)
            .frame(maxWidth: .infinity, idealHeight: 190)
            .background(Color(.systemGray6))
            
            VStack(spacing: 5) {
                Text(bookItem.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                
                Text(bookItem.subtitle ?? "")
                    .font(.system(size: 14, weight: .medium))
                
                Text(bookItem.id ?? "")
                    .font(.system(size: 12, weight: .light))
                
                Text(bookItem.price ?? "")
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .padding(.leading, 20)
            .padding(.trailing, 20)
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
