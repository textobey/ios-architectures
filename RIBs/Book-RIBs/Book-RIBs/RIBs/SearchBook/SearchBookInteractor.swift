//
//  SearchBookInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import RxSwift
import RxCocoa

protocol SearchBookRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchBookPresentable: Presentable {
    var listener: SearchBookPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var booksStream: PublishRelay<[BookItem]> { get }
}

protocol SearchBookListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchBookInteractor: PresentableInteractor<SearchBookPresentable>, SearchBookInteractable, SearchBookPresentableListener {
    
    private let repository: BookRepository
    private let serviceProvider: ServiceProviderType

    weak var router: SearchBookRouting?
    weak var listener: SearchBookListener?
    
    private var page: Int = 1
    
    init(
        presenter: SearchBookPresentable,
        repository: BookRepository,
        serviceProvider: ServiceProviderType
    ) {
        self.repository = repository
        self.serviceProvider = serviceProvider
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func search(of word: String) {
        print("search action \(word)")
        self.page = 1
        _ = fetchBookItemsResult(of: word)
            .bind(to: presenter.booksStream)
    }
    
    func paging(of word: String) {
        print("paging action \(word)")
        self.page += 1
        print("page \(page)")
        //_ = fetchBookItemsResult(of: word, page: self.page)
        //    .bind(to: presenter.booksStream)
    }
    
    func selectedBook(of item: BookItem) {
        //routeToDetail
    }
    
    private func fetchBookItemsResult(of word: String, page: Int = 1) -> Observable<[BookItem]> {
        let fetchResult = repository.fetchSearchResults(of: word, page: page)
        return Observable<[BookItem]>.create { observer in
            fetchResult.sink { result in
                switch result {
                case.success(let bookModel):
                    observer.onNext(bookModel.books ?? [])
                    observer.onCompleted()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
