import Foundation

struct Book: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let contents: String?
    let thumbnail: String?
    let price: Int?
    let sale_price: Int?
}


struct BookSearchResponse: Codable {
    let documents: [Book]
}
