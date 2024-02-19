//
//  JokeDetailView.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/19/24.
//

import SwiftUI

struct JokeDetailView: View {
    
    @State var joke: String
    
    var body: some View {
        Text(joke)
            .frame(alignment: .center)
    }
}
