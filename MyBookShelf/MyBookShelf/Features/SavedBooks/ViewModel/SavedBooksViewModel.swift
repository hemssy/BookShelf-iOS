import Foundation
import CoreData

class SavedBooksViewModel {

    private let context = CoreDataStack.context
    private(set) var savedBooks: [SavedBookEntity] = []
    
    var onUpdate: (() -> Void)?
    
    func fetchBooks() {
        let request: NSFetchRequest<SavedBookEntity> = SavedBookEntity.fetchRequest()
        do {
            savedBooks = try context.fetch(request)
            onUpdate?()
        } catch {
            print("책 불러오기 실패:", error.localizedDescription)
        }
    }

    func addBook(title: String, author: String, price: String?, thumbnailURL: String?) {
        let book = SavedBookEntity(context: context)
        book.title = title
        book.author = author
        book.price = price
        book.thumbnailURL = thumbnailURL
        book.createdAt = Date()

        do {
            try context.save()
        } catch {
        }
    }
    
    func deleteBook(_ book: SavedBookEntity) {
        context.delete(book)
        do {
            try context.save()
            fetchBooks()   
        } catch {
        }
    }
    
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedBookEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            savedBooks.removeAll()
            onUpdate?()
        } catch {
        }
    }


}

