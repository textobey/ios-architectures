//
//  LoadingButton.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/20/24.
//

import SwiftUI

struct LoadingButton: View {
    @State var isLoading = false
    
    var body: some View {
        Button(action: {
            isLoading.toggle()
        }, label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width:24, height: 24)
                        .accessibilityElement(children: .contain)
                        .accessibilityIdentifier("LoadingButton_ProgressView")
                } else {
                    Text("Button Title")
                        .foregroundColor(.white)
                        
                }
            }
            .frame(width: 140, height: 32)
            .background(Color.blue)
            .cornerRadius(8)
        })
        //.disabled(isLoading)
    }
}
