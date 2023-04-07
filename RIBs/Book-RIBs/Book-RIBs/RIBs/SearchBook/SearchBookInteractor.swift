//
//  SearchBookInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/07.
//

import RIBs
import RxSwift

protocol SearchBookRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchBookPresentable: Presentable {
    var listener: SearchBookPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchBookListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchBookInteractor: PresentableInteractor<SearchBookPresentable>, SearchBookInteractable, SearchBookPresentableListener {

    weak var router: SearchBookRouting?
    weak var listener: SearchBookListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchBookPresentable) {
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
}
