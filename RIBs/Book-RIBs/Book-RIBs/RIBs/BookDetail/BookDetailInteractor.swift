//
//  BookDetailInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs
import RxSwift
import RxRelay

protocol BookDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BookDetailPresentable: Presentable {
    var listener: BookDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var bookStream: PublishRelay<BookModel> { get }
    var isLoading: PublishRelay<Bool> { get }
    var isBookmarked: BehaviorRelay<Bool> { get }
}

protocol BookDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func detachBookDetailRIB(_ animated: Bool)
}

final class BookDetailInteractor: PresentableInteractor<BookDetailPresentable>, BookDetailInteractable, BookDetailPresentableListener {
    
    private let repository: BookRepository
    private let serviceProvider: ServiceProviderType
    
    private let isbn13: String

    weak var router: BookDetailRouting?
    weak var listener: BookDetailListener?

    init(
        presenter: BookDetailPresentable,
        repository: BookRepository,
        serviceProvider: ServiceProviderType,
        isbn13: String
    ) {
        self.repository = repository
        self.serviceProvider = serviceProvider
        self.isbn13 = isbn13
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        print("BookDetailInteractor DEINIT")
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func refresh() {
        _ = fetchBookDetail(of: self.isbn13)
            .do(onNext: { [weak self] _ in self?.presenter.isLoading.accept(false) })
            .bind(to: presenter.bookStream)
                
        _ = Observable.just(fetchBookmarked(at: isbn13))
                .bind(to: presenter.isBookmarked)
    }
    
    func bookmared() {
        _ = serviceProvider.storageService.insert(isbn13: isbn13)
            .map { _ in true }
            .bind(to: presenter.isBookmarked)
    }
    
    func unBookmakred() {
        _ = serviceProvider.storageService.delete(isbn13: isbn13)
            .map { _ in false }
            .bind(to: presenter.isBookmarked)
    }
    
    func popViewController(_ animated: Bool) {
        listener?.detachBookDetailRIB(animated)
    }
    
    private func fetchBookDetail(of isbn13: String) -> Observable<BookModel> {
        let result = repository.fetchBookDetail(of: isbn13)
        
        return Observable<BookModel>.create { [weak self] observer in
            self?.presenter.isLoading.accept(true)
            result.sink { result in
                switch result {
                case .success(let bookModel):
                    observer.onNext(bookModel)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.delay(.seconds(Int(0.5)), scheduler: MainScheduler.instance)//for loading indicator animating
    }
    
    private func fetchBookmarked(at isbn13: String) -> Bool {
        return Defaults.shared.get(for: .bookmarkList)?.contains(isbn13) ?? false
    }
}
