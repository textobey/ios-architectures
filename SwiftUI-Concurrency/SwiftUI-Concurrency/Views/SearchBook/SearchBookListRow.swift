//
//  SearchBookListRow.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/08/21.
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
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
