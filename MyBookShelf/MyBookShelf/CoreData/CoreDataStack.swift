import Foundation
import CoreData

enum CoreDataStack {
    // Persistent Container
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyBookShelf")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData 로드 실패: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // Context
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save Helper
    static func saveContextIfNeeded() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData 저장 완료")
            } catch {
                print("CoreData 저장 실패:", error.localizedDescription)
            }
        }
    }
}
