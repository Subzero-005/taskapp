//
//  EditTaskView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//

import SwiftUI
import CoreData

struct EditTaskView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode)   private var presentationMode

    @State private var title    = ""
    @State private var detail   = ""
    @State private var dueDate  = Date()
    @State private var priority = ""
    @State private var status   = ""

    let priorities = ["Low", "Medium", "High"]
    let statuses   = ["ToDo", "In Progress", "Completed"]

    var body: some View {
        Form {
            Section("Task Info") {
                TextField("Title", text: $title)
                TextField("Detail", text: $detail)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            Section("Settings") {
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id:\.self) { Text($0) }
                }
                Picker("Status", selection: $status) {
                    ForEach(statuses, id:\.self) { Text($0) }
                }
            }
        }
        .navigationTitle("Edit Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    updateTask()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            title    = task.title    ?? ""
            detail   = task.detail   ?? ""
            dueDate  = task.dueDate  ?? Date()
            priority = task.priority ?? "Medium"
            status   = task.status   ?? "ToDo"
        }
    }

    private func updateTask() {
        task.title    = title
        task.detail   = detail
        task.dueDate  = dueDate
        task.priority = priority
        task.status   = status

        do {
            try viewContext.save()
        } catch {
            let nsErr = error as NSError
            fatalError("Unresolved Core Data error: \(nsErr), \(nsErr.userInfo)")
        }
    }
}
