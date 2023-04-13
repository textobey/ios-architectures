//
//  NewBookInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import RxSwift
import RxCocoa

protocol NewBookRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToBookDetail()
}

protocol NewBookPresentable: Presentable {
    var listener: NewBookPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var booksStream: BehaviorRelay<[BookItem]> { get }
}

protocol NewBookListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class NewBookInteractor: PresentableInteractor<NewBookPresentable>, NewBookInteractable, NewBookPresentableListener {
    
    private let disposeBag = DisposeBag()
    
    private let repository: BookRepository
    private let serviceProvider: ServiceProviderType

    weak var router: NewBookRouting?
    weak var listener: NewBookListener?
    
    private var allBooks: [[BookItem]] = []

    init(
        presenter: NewBookPresentable,
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
    
    func refresh() {
        fetchBookItems()
            .compactMap { [weak self] items in
                let slicedItem = self?.sliceBookItems(items)
                self?.allBooks.removeFirst()
                return slicedItem
            }
            .bind(to: presenter.booksStream)
            .disposed(by: disposeBag)
    }
    
    func paging() {
        guard allBooks.count > 0 else { return }
        if let nextPageBooks = allBooks.first {
            var currentBooks = presenter.booksStream.value
            currentBooks.append(contentsOf: nextPageBooks)
            presenter.booksStream.accept(currentBooks)
            print("남은 책 목록")
        } else {
            print("마지막 페이지 입니다.")
        }
    }
    
    func createBookmark(of item: BookItem) {
        guard let isbn13 = item.isbn13 else { return }
        _ = serviceProvider.storageService.insert(isbn13: isbn13)
    }
    
    func undoBookmark(of item: BookItem) {
        guard let isbn13 = item.isbn13 else { return }
        _ = serviceProvider.storageService.delete(isbn13: isbn13)
    }
    
    func selectedBook(of item: BookItem) {
        router?.routeToBookDetail()
    }
    
    private func fetchBookItems() -> Observable<[BookItem]> {
        let result = repository.fetchBookItems()
        
        return Observable<[BookItem]>.create { observer in
            result.sink { result in
                switch result {
                case .success(let bookModel):
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
    
    private func sliceBookItems(_ items: [BookItem]) -> [BookItem] {
        var slicedBookItems: [[BookItem]] = [[BookItem]]()
        for i in stride(from: 0, to: items.count, by: 3) {
            if let split = items[safe: i ..< i + 3] {
                slicedBookItems.append(Array(split))
            }
        }
        // api 미제공으로 인해서 paging 기능을 위해서 로컬에 저장하고 있어요
        self.allBooks = slicedBookItems
        return slicedBookItems.first ?? []
    }
}
