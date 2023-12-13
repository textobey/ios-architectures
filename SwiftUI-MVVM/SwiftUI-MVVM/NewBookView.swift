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
    
    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "India"),
        Ocean(name: "Southern"), 
        Ocean(name: "East Sea"),
    ]
    
    let network = BookNetworking()
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(oceans) { _ in
                    ZStack {
                        NavigationLink(
                            destination: BookDetailView()
                        ) {
                            NewBookListRow()
                        }
                        .opacity(0.0)
                        
                        NewBookListRow()
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .navigationTitle("New Book")
        }
        .onAppear {
            network.request(.new)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("❎ Failed with error: \(error)")
                    case .finished:
                        print("✅ Request completed successfully.")
                    }
                }, receiveValue: { (bookModel: BookModel) in
                    print(bookModel)
                })
                .store(in: &cancellables)
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView()
    }
}
