//
//  ContentView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 01/05/25.
//
import SwiftUI
import CoreData

private let dateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateStyle = .medium
    fmt.timeStyle = .none
    return fmt
}()

struct TaskDetailView: View {
    @ObservedObject var task: Task
    let isAdmin: Bool
    let members: [User]
    let admin: User?      // now part of the initializer

    // Explicit memberwise initializer so 'admin' can be passed (with default nil)
    init(task: Task,
         isAdmin: Bool,
         members: [User],
         admin: User? = nil)
    {
        self.task = task
        self.isAdmin = isAdmin
        self.members = members
        self.admin = admin
    }

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                Text(task.title ?? "Untitled")
                    .font(.headline)
                if let detail = task.detail, !detail.isEmpty {
                    Text(detail)
                        .font(.body)
                }
                if let due = task.dueDate {
                    Text("Due: \(due, formatter: dateFormatter)")
                }
                Text("Priority: \(task.priority ?? "Medium")")
            }

            Section(header: Text("Assignment")) {
                HStack {
                    Text("Assigned To:")
                    Spacer()
                    Text(task.assignedTo?.username ?? "Unassigned")
                        .foregroundColor(.blue)
                }
                HStack {
                    Text("Assigned By:")
                    Spacer()
                    Text(task.assignedBy?.username ?? "—")
                }
                if isAdmin, let currentAdmin = admin {
                    Menu("Reassign") {
                        ForEach(members, id: \.objectID) { member in
                            Button(member.username ?? "<no name>") {
                                task.assignedTo = member
                                task.assignedBy = currentAdmin
                                save()
                            }
                        }
                    }
                }
            }

            Section(header: Text("Status")) {
                Text(task.status ?? "ToDo")
                    .font(.subheadline)
                    .foregroundColor(task.statusColor)

                if isAdmin {
                    Menu("Change Status") {
                        ForEach(["ToDo", "In Progress", "Completed"], id: \.self) { s in
                            Button(s) {
                                task.status = s
                                save()
                            }
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        Button("In Progress") { updateStatus("In Progress") }
                            .tint(.orange)
                        Button("Completed") { updateStatus("Completed") }
                            .tint(.green)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    private func updateStatus(_ newStatus: String) {
        task.status = newStatus
        save()
    }

    private func save() {
        do { try viewContext.save() }
        catch { print("Failed to save task:", error) }
    }
}
