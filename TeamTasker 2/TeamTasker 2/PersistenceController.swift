//
//  PersistenceController.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TeamTasker_2")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        for i in 0..<5 {
            let t = Task(context: viewContext)
            t.id = UUID()
            t.title = "Sample Task \(i+1)"
            t.detail = "Details for task \(i+1)"
            t.dueDate = Calendar.current.date(byAdding: .day, value: i, to: Date())
            t.priority = ["Low","Medium","High"][i%3]
            t.status = ["ToDo","In Progress","Completed"][i%3]
        }
        do { try viewContext.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved Core Data error: \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()
}
