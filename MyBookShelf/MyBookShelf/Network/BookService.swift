import Foundation

class BookService {
    static let shared = BookService()
    private init() {}

    private let baseURL = "https://dapi.kakao.com/v3/search/book"
    private let apiKey = "8d202de167a18183b95c113117709918" // 나중에 .xcconfig로 분리하기

    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")


        URLSession.shared.dataTask(with: request) { data, response, error in
            // [디버깅1] 에러 체크
            if let error = error {
                print("네트워크 에러 발생:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            // [디버깅2] HTTP 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse {
                print("응답 코드:", httpResponse.statusCode)
            }

            // [디버깅3] 실제 응답 데이터 확인 (문자열 형태)
            if let data = data,
               let jsonString = String(data: data, encoding: .utf8) {
                print("응답 JSON 미리보기:\n\(jsonString.prefix(300))...\n")
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "noData", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(BookSearchResponse.self, from: data)
                completion(.success(decoded.documents))
                print("디코딩 성공 — 책 개수:", decoded.documents.count)
            } catch {
                print("디코딩 에러:", error)
                completion(.failure(error))
            }
        }.resume()
    }
}

