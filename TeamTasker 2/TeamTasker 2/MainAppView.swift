//
//  MainAppView.swift
//  TeamTasker 2
//
//  Created by adhiraj madan on 28/04/25.
//


import SwiftUI

struct MainAppView: View {
    @ObservedObject var user: User

    var body: some View {
        Group {
            if user.role == UserRole.Admin.rawValue {
                AdminDashboardView(admin: user)
            } else {
                UserDashboardView(user: user)
            }
        }
    }
}
