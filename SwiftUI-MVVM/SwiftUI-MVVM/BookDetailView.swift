//
//  BookDetailView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct BookDetailView: View {
    var body: some View {
        // Depth로 들어가는 화면이기 때문에, 여기서 NavigationView를 또 만들지 않음.
        //NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Image(systemName: "book")
                        .resizable()
                        .frame(width: 100)
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 230)
                .background(Color(.systemGray5))
                
                VStack(spacing: 6) {
                    Text("Book Name")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.top, 20)
                    
                    Text("Book SubTitle")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("Book id(number)")
                        .font(.system(size: 12, weight: .light))
                    
                    Text("Book Price")
                        .font(.system(size: 12, weight: .medium))
                    
                    Text("Book link")
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                Divider()
                    .background(Color(.systemGray5))
                    .frame(maxHeight: 0.1)
                    .padding(20)// 트러블슈팅: 디바이더를 VStack 안쪽에 넣으니까, Spacing으로 인해 늘어나는 문제가 있어서 VStack 바깥 블록으로 빼냈어요.
                
                Text("TODO: CustomTextView")
            }
            .navigationTitle("Detail Book")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            // 트러블슈팅: VStack이 SafeArea 영역을 무시하고 침범하여 꽉채우는 문제가 있어서 설정해줬어요.
            .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
        //}
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView()
    }
}
