import Foundation

struct Book: Codable {
    let title: String
    let authors: [String]
    let publisher: String
    let thumbnail: String?
    let contents: String?
}

struct BookSearchResponse: Codable {
    let documents: [Book]
}
