//
//  JokeView.swift
//  MyOceanTests
//
//  Created by 이서준 on 2/19/24.
//

import SwiftUI

struct JokeView: View {
    
    var viewModel: DeepOceanViewModel
    
    var body: some View {
        List(viewModel.jokeList, id: \.self) { joke in
            NavigationLink(
                destination: {
                    JokeDetailView(joke: joke)
                },
                label: {
                    Text(joke)
                        .frame(alignment: .leading)
                }
            )
        }
    }
}
