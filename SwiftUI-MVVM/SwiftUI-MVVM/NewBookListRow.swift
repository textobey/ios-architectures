//
//  NewBookListRow.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct NewBookListRow: View {
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 140)
            }
            .frame(maxWidth: .infinity, idealHeight: 190)
            .background(Color(.systemGray6))
            
            VStack {
                Text("Book Name")
                
                Text("Book Description")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .padding(.top, 15)
            .padding(.bottom, 15)
            .background(Color(.systemGray5))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct NewBookListRow_Previews: PreviewProvider {
    static var previews: some View {
        NewBookListRow()
    }
}
