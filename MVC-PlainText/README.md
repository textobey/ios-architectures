
### 요구사항
- (Important)최대한 코드 어시스트, 검색 등의 방법을 활용하지 않고 Plain Text 만으로 작성
- MVC 디자인 패턴으로, 서드파티 라이브러리 활용없이 구현
    - 추후에 서드파티 라이브러리를 활용하는 방향도 고려
- BookViewController1, BookViewController2을 구현하여 BookTabBarViewController의 RootView로 설정
- 다수의 API를 처리할 수 있는 네트워크 통신 모듈 구현
    - UI를 통해 필요한 프로퍼티를 파악하여 모델 구현. 단, 각각 Cell을 구성하는 타입은 3가지로(Book Name, Book AD, Book Image AD) 하나의 API Response 수신되기에 각 타입별로 Cell의 구성을 다르게 해야함
    - 네트워크 통신으로 얻은 Response를 각각 알맞은 UI에 업데이트
- (Important)각 화면에서 ☆(Bookmark) 버튼의 상태는 동일해야함(BookViewController1에서 북마크된 책은 화면 전환시 BookViewController2에서도 북마크 상태여야함)
    - 단, 각 화면마다 API의 요청은 한번만 이루어져야 하기 때문에, 북마크 상태 확인을 위해 API를 다시 요청하지 않아야함. 앱단에서 동일하게 처리
     - 북마크 요청 API는 성공 여부에 대한 결과를 상관하지 않아도 됨

### BookViewController1, BookViewController2
![](https://velog.velcdn.com/images/textobey/post/bf4b21c6-c76c-483e-a7a7-8a8d39f4f479/image.png)

### BookTabBarViewController
![](https://velog.velcdn.com/images/textobey/post/7c4925c6-82a9-4956-8aa5-8bd4051f9b61/image.png)
