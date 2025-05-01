import SwiftUI
import CoreData

struct UserDashboardView: View {
    @ObservedObject var user: User
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch only tasks assigned to this user
    @FetchRequest private var tasks: FetchedResults<Task>
    init(user: User) {
        let predicate = NSPredicate(format: "assignedTo == %@", user)
        _tasks = FetchRequest(
            entity: Task.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
            predicate: predicate
        )
        self.user = user
    }

    // For presenting detail sheet if needed
    @State private var selectedTask: Task?

    var body: some View {
        NavigationView {
            List {
                if tasks.isEmpty {
                    Text("No tasks assigned")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.background)
                } else {
                    ForEach(tasks) { task in
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

                            // Menu for status selection
                            Menu {
                                Button("To Do") {
                                    update(task: task, status: "ToDo")
                                }
                                Button("In Progress") {
                                    update(task: task, status: "In Progress")
                                }
                                Button("Completed") {
                                    update(task: task, status: "Completed")
                                }
                            } label: {
                                Text(task.status ?? "ToDo")
                                    .font(.subheadline)
                                    .foregroundColor(task.statusColor)
                                    .padding(6)
                                    .background(Color(UIColor.secondarySystemFill))
                                    .cornerRadius(6)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTask = task
                        }
                        .listRowBackground(Color.background)
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("My Tasks")
            .accentColor(.primaryAccent)
            // Show detail in a sheet if tapped
            .sheet(item: $selectedTask) { task in
                NavigationView {
                    TaskDetailView(
                        task: task,
                        isAdmin: false,
                        members: [],
                        admin: nil   // <-- provide the missing 'admin' argument
                    )
                    .accentColor(.primaryAccent)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                selectedTask = nil
                            }
                        }
                    }
                }
            }
        }
    }

    private func update(task: Task, status: String) {
        task.status = status
        saveContext()
    }

    private func deleteTasks(offsets: IndexSet) {
        offsets.map { tasks[$0] }
               .forEach(viewContext.delete)
        saveContext()
    }

    private func saveContext() {
        do { try viewContext.save() }
        catch { print("Error saving context:", error) }
    }
}
