//
//  AdminDashboardView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//
import SwiftUI
import CoreData

struct AdminDashboardView: View {
    @ObservedObject var admin: User
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch all tasks, sorted by title
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)]
    ) private var tasks: FetchedResults<Task>

    // Fetch only non‑admin users (members) to assign tasks to
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)],
        predicate: NSPredicate(format: "role == %@", UserRole.User.rawValue)
    ) private var members: FetchedResults<User>

    @State private var showingAddTask = false
    private let statuses = ["ToDo", "In Progress", "Completed"]

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    NavigationLink(
                        destination: TaskDetailView(
                            task: task,
                            isAdmin: true,
                            members: Array(members),
                            admin: admin
                        )
                    ) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(task.title ?? "Untitled Task")
                                    .font(.headline)
                                if let detail = task.detail, !detail.isEmpty {
                                    Text(detail)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text(task.status ?? "ToDo")
                                .font(.subheadline)
                                .foregroundColor(task.statusColor)
                                .padding(6)
                                .background(Color(UIColor.secondarySystemFill))
                                .cornerRadius(6)
                        }
                        .padding(.vertical, 6)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            task.status = "In Progress"
                            saveContext()
                        } label: {
                            Label("In Progress", systemImage: "clock")
                        }
                        .tint(.orange)

                        Button {
                            task.status = "Completed"
                            saveContext()
                        } label: {
                            Label("Complete", systemImage: "checkmark.circle")
                        }
                        .tint(.green)
                    }
                    .listRowBackground(Color.background)
                }
                .onDelete(perform: deleteTasks)
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("Admin Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Task")
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(admin: admin)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        offsets.map { tasks[$0] }.forEach(viewContext.delete)
        saveContext()
    }

    private func saveContext() {
        do { try viewContext.save() }
        catch { print("Error saving context:", error) }
    }
}
