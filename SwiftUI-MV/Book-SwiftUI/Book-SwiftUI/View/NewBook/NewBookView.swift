//
//  NewBookView.swift
//  Book-SwiftUI
//
//  Created by 이서준 on 2023/05/04.
//

import SwiftUI

struct NewBookView: View {
    
    // MARK: - Properties
    
    @State private var isBookmarked = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                ZStack {
                    Image(systemName: "book.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                .frame(height: 200)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Book title")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Book Subtitle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("ISBN13: 1234567890123")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "dollarsign.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("$ 9.99")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        isBookmarked.toggle()
                    }) {
                        Image(systemName: isBookmarked ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                //.background(UIColor.systemGray5)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .navigationTitle("New Book")
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
