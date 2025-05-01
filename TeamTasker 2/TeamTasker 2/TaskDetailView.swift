//
//  TaskDetailView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 01/05/25.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var currentUser: User

    // For presenting detail sheet if needed (e.g. from notifications or deep‑link)
    @State private var selectedTask: Task?

    var body: some View {
        NavigationView {
            if currentUser.role == UserRole.Admin.rawValue {
                AdminDashboardView(admin: currentUser)
                    .environment(\.managedObjectContext, viewContext)
            } else {
                UserDashboardView(user: currentUser)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        // Example sheet: if you ever present TaskDetailView from here,
        // be sure to include the `admin:` argument to match its initializer.
        .sheet(item: $selectedTask) { task in
            NavigationView {
                TaskDetailView(
                    task: task,
                    isAdmin: currentUser.role == UserRole.Admin.rawValue,
                    members: fetchMembers(),  // or pass an appropriate array
                    admin: currentUser        // must pass admin or nil
                )
                .environment(\.managedObjectContext, viewContext)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { selectedTask = nil }
                    }
                }
            }
        }
    }

    // Helper to load non‑admin users when presenting from ContentView
    private func fetchMembers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "role == %@", UserRole.User.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \User.username, ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch members:", error)
            return []
        }
    }
}
