import UIKit
import Foundation

class BookDetailViewModel {
    private let book: Book
    var title: String { book.title }
    var author: String { book.authors?.joined(separator: ", ") ?? "저자 미상" }
    var priceText: String {
        if let p = book.price {
            return "\(p)원"
        } else { return "가격 정보 없음" }
    }
    var contents: NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 13
        return NSAttributedString(
            string: book.contents ?? "내용 없음",
            attributes: [.paragraphStyle: paragraph]
        )
    }
    var thumbnailURL: URL? {
        if let url = book.thumbnail { return URL(string: url) }
        return nil
    }

    init(book: Book) {
        self.book = book
    }
}

