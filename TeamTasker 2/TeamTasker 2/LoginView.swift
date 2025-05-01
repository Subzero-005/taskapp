//
//  LoginView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMsg: String = ""
    @State private var loggedInUser: User?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Credentials")) {
                    TextField("Email", text: $email)
#if os(iOS)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
#endif
                    SecureField("Password", text: $password)
                }

                if !errorMsg.isEmpty {
                    Section {
                        Text(errorMsg)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Login")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Login") {
                        authenticate()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                }
            }
        }
        .fullScreenCover(item: $loggedInUser) { user in
            MainAppView(user: user)
                .environment(\.managedObjectContext, viewContext)
        }
    }

    private func authenticate() {
        let req: NSFetchRequest<User> = User.fetchRequest()
        req.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        req.fetchLimit = 1

        do {
            let results = try viewContext.fetch(req)
            if let u = results.first {
                loggedInUser = u
            } else {
                errorMsg = "Invalid credentials"
            }
        } catch {
            errorMsg = "Login failed"
        }
    }
}
