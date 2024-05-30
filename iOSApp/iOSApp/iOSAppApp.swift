//
//  iOSAppApp.swift
//  iOSApp
//
//  Created by Samuel Langarica on 02/05/24.
//

import SwiftUI
import Firebase

@main
struct iOSAppApp: App {
    @StateObject private var appState = AppState()
    
    init()
    {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                HomeView()
                    .environmentObject(appState)
            } else {
                LoginView(email: "", password: "")
                    .environmentObject(appState)
            }
        }
    }
}
