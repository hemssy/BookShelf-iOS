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
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "noData", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(BookSearchResponse.self, from: data)
                completion(.success(decoded.documents))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

