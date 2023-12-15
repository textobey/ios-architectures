//
//  BookDetailView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 12/4/23.
//

import SwiftUI

struct BookDetailView: View {
    
    let isbn13: String
    
    @ObservedObject var viewModel: BookDetailViewModel
    
    @State private var text: String = ""
    @State private var placeholder: String = "Write down how you feel about the book."
    
    var body: some View {
        // Depth로 들어가는 화면이기 때문에, 여기서 NavigationView를 또 만들지 않음.
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Image(systemName: "book")
                        .resizable()
                        .frame(width: 100, height: 170)
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                        .frame(width: 100)
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
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.black)
                        .frame(height: 230)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        // 트러블슈팅
                        // SwiftUI의 ZStack은 자체적으로 cornerRadius를 갖지 않기 때문에, 각 뷰에 직접 적용해야해요.
                        // 하지만, TextEditor cornerRadius를 지원하지 않아서 아래의 방법을 사용해요.
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray5), lineWidth: 1))
                    
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.primary.opacity(0.2))
                            .padding(EdgeInsets(top: 18, leading: 15, bottom: 10, trailing: 10))
                            .lineSpacing(0)
                    }
                        
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .frame(maxHeight: 230)
            }
        }
        .navigationTitle("Detail Book")
        .navigationTitle("Detail Book")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // 트러블슈팅: VStack이 SafeArea 영역을 무시하고 침범하여 꽉채우는 문제가 있어서 설정해줬어요.
        .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
        .onAppear {
            self.viewModel.transform(.load(self.isbn13))
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(isbn13: "", viewModel: BookDetailViewModel())
    }
}
