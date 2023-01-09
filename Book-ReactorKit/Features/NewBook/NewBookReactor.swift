//
//  NewBookReactor.swift
//  Book-ReactorKit
//
//  Created by 이서준 on 2022/12/01.
//

import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import UserNotifications

class NewBookReactor: Reactor {
    fileprivate var allBooks: [[BookItem]] = []
    
    enum Action {
        case refresh
        case paging
        case bookmark(Bool, BookItem)
    }
    
    enum Mutation {
        case setBooks([BookItem])
        case pagingBooks
        case setLoading(Bool)
        case showAlert
        case printBook([AnyHashable: Any])//For Test
    }
    
    struct State {
        var books: [BookItem] = []
        var isLoading: Bool = false
        @Pulse var alertTrigger: Void = Void()
    }
    
    let initialState = State()
    
    init() {
        requestNotificationAuthorization()
        sendNotification(seconds: 5)
    }
}

extension NewBookReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                fetchBookItemsResult().flatMap { bookItems -> Observable<Mutation> in
                    return Observable.just(.setBooks(bookItems))
                }.delay(.seconds(Int(0.5)), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        case .paging:
            guard allBooks.count > 0 else { return .empty() }
            return Observable.just(.pagingBooks)
        case .bookmark(let isSelected, let bookItem):
            if let isbn13 = bookItem.isbn13 {
                if isSelected {
                    print("새로운 즐겨찾기 추가 :", bookItem.title)
                    Defaults.shared.appendBookmark(isbn13: isbn13)
                } else {
                    print("즐겨찾기 제거 :", bookItem.title)
                    Defaults.shared.removeBookmark(isbn13: isbn13)
                }
            }
            return .empty()
        }
    }
}

extension NewBookReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBooks(let bookItems):
            let slicedBookImtes = sliceBookItems(bookItems)
            allBooks = slicedBookImtes
            newState.books = slicedBookImtes.first ?? []
            allBooks.removeFirst()
            print("남은 책 목록", allBooks.count)
        case .pagingBooks:
            if let nextBooks = allBooks.first {
                newState.books.append(contentsOf: nextBooks)
                allBooks.removeFirst()
                print("남은 책 목록", allBooks.count)
            } else {
                print("마지막 페이지 입니다.")
            }
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .showAlert:
            newState.alertTrigger = Void()
        case .printBook(let book):
            print(book)
        }
        return newState
    }
}

extension NewBookReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = GlobalEventsDispatcher.shared.rx.globalEventStream.flatMap { event -> Observable<Mutation> in
            switch event {
            case .willPresentNotification:
                return Observable.just(.showAlert)
            case .didReceiveNotification(let object):
                return Observable.just(.printBook(object!))
            default:
                print("NewBookReactor Mutation Other...")
                return .empty()
            }
        }
        return Observable.merge(mutation, eventMutation)
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let eventAction = GlobalEventsDispatcher.shared.rx.globalEventStream.flatMap { event -> Observable<Action> in
            switch event {
            case .updateBookmarkList:
                print("NewBookReactor refresh action")
                return Observable.just(.refresh)
            default:
                print("NewBookReactor Mutation Other...")
                return .empty()
            }
        }
        return Observable.merge(action, eventAction)
    }
}

private extension NewBookReactor {
    func fetchBookItemsResult() -> Observable<[BookItem]> {
        let fetchResult = NetworkService.shared.fetchBookItems()
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
    
    private func sliceBookItems(_ bookItems: [BookItem]) -> [[BookItem]] {
        var slicedBookItems: [[BookItem]] = [[BookItem]]()
        for i in stride(from: 0, to: bookItems.count, by: 3) {
            if let split = bookItems[safe: i ..< i + 3] {
                slicedBookItems.append(Array(split))
            }
        }
        return slicedBookItems
    }
}

// MARK: - Local Notification
extension NewBookReactor {
    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    private func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "새로운 책들을 확인해보세요."
        notificationContent.body = "베스트 셀러 작가들의 신규 책들이 발간 되었어요!"
        notificationContent.userInfo = ["name":"A Swift Kickstart, 2nd Edition"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: notificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
