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
    
    var body: some View {
        // Depth로 들어가는 화면이기 때문에, 여기서 NavigationView를 또 만들지 않음.
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    AsyncImageView(urlString: viewModel.bookItem?.image)
                        .frame(width: 150, height: 170)
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 230)
                .background(Color(.systemGray5))
                
                VStack(spacing: 6) {
                    Text(viewModel.bookItem?.title ?? "")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.bookItem?.subtitle ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.bookItem?.isbn13 ?? "")
                        .font(.system(size: 12, weight: .light))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(viewModel.bookItem?.price ?? "")
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(viewModel.bookItem?.url ?? "")
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                Divider()
                    .background(Color(.systemGray5))
                    .frame(maxHeight: 0.1)
                    .padding(20)// 트러블슈팅: 디바이더를 VStack 안쪽에 넣으니까, Spacing으로 인해 늘어나는 문제가 있어서 VStack 바깥 블록으로 빼냈어요.
                
                // 트러블슈팅
                // 내부의 text가 @State 어트리뷰트이기 때문에, 변경시마다 body 내부가 모두 다시 그려지는데,
                // TextEditor 영역에 해당하는곳만 다시 그려지길 원하기 때문에, 하위뷰로 분리했어요.
                BookMemoView()
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .frame(maxHeight: 230)
            }
        }
        .navigationTitle("Detail Book")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // 트러블슈팅: VStack이 SafeArea 영역을 무시하고 침범하여 꽉채우는 문제가 있어서 설정해줬어요.
        .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
        .onAppear {
            self.viewModel.transform(.load(self.isbn13))
        }
        // 트러블슈팅: UIKit의 hidesbottombarwhenpushed를 구현하기 위해서는
        // iOS16미만: TabView보다 NavigationView를 상위 계층으로 두기
        // iOS16이상: .toolbar(.hidden, .tabBar)를 사용 -> 문제는 hidesbottombarwhenpushed만큼 부드럽지 못해요.
        .toolbar(.hidden, for: .tabBar)
        .scrollDismissesKeyboard(.immediately)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(
            isbn13: "9781912047451",
            viewModel: BookDetailViewModel()
        )
    }
}
