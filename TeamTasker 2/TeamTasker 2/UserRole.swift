//
//  UserRole.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//
import Foundation

/// Strongly‑typed roles for your app
enum UserRole: String, CaseIterable, Identifiable {
    case Admin
    case User

    var id: String { rawValue }
}
