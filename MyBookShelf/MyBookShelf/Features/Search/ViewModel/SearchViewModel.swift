import Foundation

class SearchViewModel {
    
    // API 요청할 때 사용할 서비스
    let service = BookService.shared
    
    // 화면에 보여줄 책 목록
    var books: [Book] = []
    
    // 화면에 데이터 새로고침하라고 알려줄 때 사용
    var whenUpdated: (() -> Void)?
    
    // 화면에 에러났다고 알려줄 때 사용
    var whenError: ((String) -> Void)?
    
    // 실제 검색하는 함수
    func searchBooks(query: String) {
        
        // BookService한테 검색해달라고 부탁
        service.searchBooks(query: query) { result in
            
            // 화면을 바꾸는 일은 메인 스레드에서 실행해야 함
            DispatchQueue.main.async {
                
                // 성공했을 때
                if case .success(let foundBooks) = result {
                    self.books = foundBooks
                    self.whenUpdated?()   // 화면에 업데이트됐다고 알림
                    
                // 실패했을 때
                } else if case .failure(let error) = result {
                    self.books = []
                    self.whenError?(error.localizedDescription)
                }
            }
        }
    }
}

