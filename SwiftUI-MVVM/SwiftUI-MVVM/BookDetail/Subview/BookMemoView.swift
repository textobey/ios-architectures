//
//  BookMemoView.swift
//  SwiftUI-MVVM
//
//  Created by 이서준 on 1/9/24.
//

import SwiftUI

struct BookMemoView: View {
    
    @State var text: String = ""
    @State var placeholder: String = "Write down how you feel about the book."
    
    var body: some View {
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
            
            // placeholder 기능을 지원하지 않기에, @State text의 상태를 관찰하며 isEmpty일 경우 표시
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.primary.opacity(0.2))
                    .padding(EdgeInsets(top: 18, leading: 15, bottom: 10, trailing: 10))
                    .lineSpacing(0)
            }
        }
    }
}
