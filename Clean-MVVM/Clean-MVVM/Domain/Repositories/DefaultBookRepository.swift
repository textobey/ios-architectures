//
//  DefaultBookRepository.swift
//  Clean-MVVM
//
//  Created by 이서준 on 3/20/24.
//

import Foundation
import Combine

class DefaultBookRepository {
    
    private let dataTransferSerivce: DataTransferService
    
    init(dataTransferSerivce: DataTransferService) {
        self.dataTransferSerivce = dataTransferSerivce
    }
}

extension DefaultBookRepository: BookRepository {
    func fetchNewBook() -> AnyPublisher<BooksPage, Error> {
        let endPoint = BookAPIEndPoint.fetchBooks()
        return dataTransferSerivce.request(endPoint: endPoint)
            // Q. DataTransferError to Error. 변환 과정이 필요할까?..
            // A. 하다보니 문득 알게된거 같아서..내가 나에게 주는 답변
            //    Data Layer에 존재하는 DataTransferError 객체를
            //    Domain Layer에 가져가서는 안됨(가져간다 표현하는게 적합?한지는 모르겠음)
            //
            // Q. 그럼, BookPage는 Domain Layer에 존재하는 엔티티인데
            //    Data Layer에서 사용하는건 상관 없을까?
            // A. ㅇㅇ Data Layer는 Domain Layer를 의존하는걸?
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
