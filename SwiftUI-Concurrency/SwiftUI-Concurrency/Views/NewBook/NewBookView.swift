//
//  NewBookView.swift
//  SwiftUI-Concurrency
//
//  Created by 이서준 on 2023/07/24.
//

import SwiftUI

struct NewBookView: View {
    
    let networking: BookNetworking = DefaultBookNetworking()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                Task {
                    let books = try await networking.fetchNewBooks()
                    print(books)
                }
            }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
