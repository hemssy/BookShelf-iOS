# <img width="50" height="50" alt="icon-ios-40x40@2x" src="https://github.com/user-attachments/assets/ee22972d-eacf-46d7-9029-38a5b12387ac" /> &nbsp;BookShelf-iOS

사용자가 책을 검색하고, 상세 정보를 확인한 뒤 내 책장에 담아 관리할 수 있는 iOS 앱입니다.
최근 본 책은 자동으로 기록됩니다.

[카카오 책 검색 REST API](https://developers.kakao.com/docs/latest/ko/daum-search/dev-guide#search-book$0)로 도서 정보를 불러오며, SnapKit과 Core Data, UserDefaults를 사용해 UI와 데이터 저장을 구현했습니다.

<br>

## 프로젝트 소개 
- Kakao Book REST API를 이용해 도서 검색 및 상세 정보를 제공합니다.
- 사용자가 담은 책은 **Core Data**에 저장되어 앱을 종료해도 유지됩니다.
- 상세 화면을 닫으면 **최근 본 책**이 자동으로 갱신되어 검색화면에서 접근할 수 있습니다.
- MVVM 패턴을 기반으로 **View / ViewModel / Model** 간의 의존성을 최소화하고, NotificationCenter와 Delegate를 활용해 화면 간 데이터 갱신을 효율적으로 처리했습니다.

<br>

## 개발 환경

![iOS Version](https://img.shields.io/badge/iOS-18.5-lightgrey.svg?style=for-the-badge&logo=apple&logoColor=white)&nbsp;&nbsp;&nbsp;![Xcode Version](https://img.shields.io/badge/Xcode-16.4-blue.svg?style=for-the-badge&logo=xcode&logoColor=white)&nbsp;&nbsp;&nbsp;![Swift Version](https://img.shields.io/badge/Swift-6.1.2-orange.svg?style=for-the-badge&logo=swift&logoColor=white)&nbsp;&nbsp;&nbsp;
[![SnapKit 5.7.1](https://img.shields.io/badge/SnapKit-5.7.1-0A99E2?style=for-the-badge&logo=data:image/svg+xml;base64,여기에인코딩된문자열&logoColor=white)](https://github.com/SnapKit/SnapKit)

<br>

## 주요 기능 

| 기능 구분 | 설명 | 실행 화면 |
|------------|-------|-------------|
| **도서 검색 (Search)** | - Kakao Book API로 책 제목, 저자, 출판사 기반 검색<br>- 검색 결과를 **UITableView** 형태로 표시<br>- 책 선택 시 **상세 모달(Book Detail)** 로 이동 | - |
| **책 상세 모달 (Book Detail)** | - 책 제목, 저자, 가격, 소개, 썸네일 이미지 표시<br>- **“담기” 버튼 탭** -> Core Data에 저장<br>- **“X” 버튼** -> 모달 닫기<br>- 모달 닫을 때 자동으로 “최근 본 책” 추가 | - |
| **내 책장 (Saved Books)** | - 사용자가 담은 책 목록 표시<br>- **스와이프**로 개별 삭제 가능<br>- **“전체 삭제” 버튼**으로 모든 책 초기화 | - |
| **최근 본 책 (Recent Books)** | - 상세 모달에서 본 책을 **UserDefaults**에 저장<br>- 가장 최근 10권까지 저장 및 표시<br>- **검색결과 화면 상단 섹션**에 컬렉션뷰로 표시 | - |

<br>

## 아키텍처 개요 👷

**MVVM (Model–View–ViewModel)** 패턴을 적용했습니다.
Model은 책 데이터와 관련된 구조체 및 코어데이터 엔티티를 정의하고,
ViewModel은 로직과 데이터 흐름을 관리하며,
View는 변화된 데이터를 화면에 표시하는 역할을 합니다.

<br>

### 🏗️ 계층별 역할

| 계층 구분 | 주요 폴더 | 책임 |
|------|------------|------|
| View | `Features/Search/View`, `Features/SavedBooks/View`, `Features/RecentBooks/View` | UIKit 기반 UI, 사용자 인터랙션 처리 |
| ViewModel | `Features/BookDetail/ViewModel`, `Features/SavedBooks/ViewModel`, `Features/Search/ViewModel`   | Core Data 또는 API 호출 결과를 가공하여 View에 전달 |
| Model | `Features/Search/Model`, `CoreData/MyBookShelf` | Book 구조체, SavedBookEntity 정의 |
| Service | `Network/BookService` | Kakao Book REST API 통신 및 데이터 파싱 |
| Storage | `CoreData/CoreDataStack` | Core Data 관리 및 저장 |

<br>

### 🏗️ 데이터 흐름

1. 사용자가 검색어 입력 -> **SearchViewModel**로 전달  
2. SearchViewModel이 **BookService**를 통해 API 요청 수행  
3. 응답받은 도서 데이터를 `Book` 모델 배열로 변환  
4. **ViewModel**이 `onUpdate` 클로저를 통해 View에 전달  
5. 테이블뷰가 `reloadData()` 로 검색 결과를 렌더링  
6. 상세 모달에서 '담기' 버튼 탭 시 **SavedBooksViewMode**l이 **코어데이터**에 추가
7. `BookAdded` 알림을 받아서 **SavedBooksViewController**가 UI 갱신
8. 상세 모달 열람 시 **BookDetailViewController**가 책 정보를 **유저디폴트**의 `recentBooks`에 저장
9. 상세 모달 닫힘 시 **BookDetailViewController**가 `RecenetBooksUpdated` 알림 전송
10. **SearchViewController**가 유저디폴트에서 데이터를 다시 불러와서 UI 갱신

<br>

## 디렉토리 구조 📂

```text

```

<br>

## 트러블슈팅 🔫

### [위키 바로가기](https://github.com/hemssy/BookShelf-iOS/wiki/Home👷)
