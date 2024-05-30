//
//  AppState.swift
//  iOSApp
//
//  Created by Samuel Langarica on 28/05/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func signIn() {
        self.isAuthenticated = true
    }
    
    func signOut() {
        self.isAuthenticated = false
    }
}
