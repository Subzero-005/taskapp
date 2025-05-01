//
//  SignUpView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//


import SwiftUI
import CoreData

struct SignUpView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode)   private var presentationMode

    @State private var email: String    = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var role: UserRole   = .User

    var body: some View {
        NavigationView {
            Form {
                Section("Credentials") {
                    TextField("Email", text: $email)
#if os(iOS)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
#endif
                    TextField("Username", text: $username)
#if os(iOS)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
#endif
                    SecureField("Password", text: $password)
                }
                Section("Role") {
                    Picker("Select Role", selection: $role) {
                        ForEach(UserRole.allCases) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createUser()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(email.isEmpty || username.isEmpty || password.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func createUser() {
        let newUser = User(context: viewContext)
        newUser.id       = UUID()
        newUser.email    = email
        newUser.username = username
        newUser.password = password
        newUser.role     = role.rawValue

        do {
            try viewContext.save()
        } catch {
            let nsErr = error as NSError
            fatalError("Unresolved Core Data error: \(nsErr), \(nsErr.userInfo)")
        }
    }
}
