//
//  RootInteractor.swift
//  Book-RIBs
//
//  Created by 이서준 on 2023/04/11.
//

import Foundation
import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachTabs()
    func routeNewBook() -> NewBookActionableItem
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor:
    PresentableInteractor<RootPresentable>,
    RootInteractable,
    RootPresentableListener,
    RootActionableItem,
    UrlHandler {

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    // MARK: Deeplink
    
    //private let newBookActionableItemSubject = ReplaySubject<NewBookActionableItem>.create(bufferSize: 1)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        router?.attachTabs()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func handle(_ url: URL) {
        let workflow = LoadPopularBookWorkflow(url: url)
        
        workflow
            .subscribe(self)
            .disposeOnDeactivate(interactor: self)
    }
    
    func waitForRequest() -> Observable<(NewBookActionableItem, String)> {
        if let newBookActionableItem = router?.routeNewBook() {
            return Observable.just(newBookActionableItem)
                .map { newBookActionableItem -> (NewBookActionableItem, String) in
                    (newBookActionableItem, "Load PopularBook Request")
                }
        }
        return Observable.empty()
    }
}
