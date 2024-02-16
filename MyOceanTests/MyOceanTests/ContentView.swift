//
//  ContentView.swift
//  MyOceanTests
//
//  Created by 이서준 on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Registration")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                TextField("UserName", text: $userName)
                    .font(.title2)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                
                NavigationLink(
                    destination: {
                        DetailView(userName: $userName)
                    },
                    label: {
                        Text("Sign Up")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                )
                .disabled(userName.isEmpty)
                .opacity(userName.isEmpty ? 0.6 : 1)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
