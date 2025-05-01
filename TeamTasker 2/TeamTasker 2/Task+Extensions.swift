//
//  Task+Extensions.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 01/05/25.
//
import SwiftUI
import CoreData

extension Task {
    var statusText: String {
        guard let s = status, let v = Int(s) else { return "—" }
        return v == 0 ? "Pending" : "Done"
    }

    var statusColor: Color {
        guard let s = status, let v = Int(s) else { return .primary }
        return v == 0 ? .orange : .green
    }

    var statusIcon: String {
        guard let s = status, let v = Int(s) else { return "questionmark.circle" }
        return v == 0 ? "hourglass" : "checkmark.circle.fill"
    }
}
