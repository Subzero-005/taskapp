//
//  TaskRowView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//
import SwiftUI

struct TaskRowView: View {
    let task: Task

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "Untitled Task")
                    .font(.headline)

                if let detail = task.detail, !detail.isEmpty {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(task.status ?? "ToDo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            let done = (task.status ?? "ToDo") == "Completed"
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.blue)
        }
    }
}
