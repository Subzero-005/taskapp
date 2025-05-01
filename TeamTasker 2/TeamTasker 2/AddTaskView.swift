//
//  AddTaskView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//


import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    let admin: User

    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: String = "Medium"
    private let priorities = ["Low", "Medium", "High"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Detail")) {
                    TextField("Enter details", text: $detail)
                }
                Section(header: Text("Due Date")) {
                    DatePicker("", selection: $dueDate, displayedComponents: .date)
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNewTask()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveNewTask() {
        let newTask = Task(context: viewContext)
        newTask.title = title
        newTask.detail = detail
        newTask.dueDate = dueDate
        newTask.priority = priority
        newTask.status = "ToDo"
        newTask.assignedBy = admin        // record which admin created it
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save new task:", error)
        }
    }
}
