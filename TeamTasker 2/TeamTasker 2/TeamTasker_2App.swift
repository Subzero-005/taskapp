//
//  TeamTasker_2App.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 01/05/25.
//
import SwiftUI

@main
struct TeamTasker2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}
