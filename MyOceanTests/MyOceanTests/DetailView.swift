//
//  DetailView.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/2/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var userName: String

    var body: some View {
        VStack {
            Text(userName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
