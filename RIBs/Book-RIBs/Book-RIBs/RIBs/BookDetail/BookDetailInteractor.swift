//
//  BookDetailInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/14.
//

import RIBs
import RxSwift

protocol BookDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BookDetailPresentable: Presentable {
    var listener: BookDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BookDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func detachBookDetailRIB(_ animated: Bool)
}

final class BookDetailInteractor: PresentableInteractor<BookDetailPresentable>, BookDetailInteractable, BookDetailPresentableListener {
    
    private let repository: BookRepository
    private let serviceProvider: ServiceProviderType

    weak var router: BookDetailRouting?
    weak var listener: BookDetailListener?

    init(
        presenter: BookDetailPresentable,
        repository: BookRepository,
        serviceProvider: ServiceProviderType
    ) {
        self.repository = repository
        self.serviceProvider = serviceProvider
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        print("DEINIT")
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        print("will resign active")
    }
    
    func popViewController(_ animated: Bool) {
        listener?.detachBookDetailRIB(animated)
    }
}
