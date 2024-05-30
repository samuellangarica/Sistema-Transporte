//
//  ProfileView.swift
//  iOSApp
//
//  Created by Samuel Langarica on 02/05/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = "Unknown"
    @State private var apellido: String = "Unknown"
    @State private var carrera: String = "Unknown"
    @State private var semestre: String = "Unknown"
    @State private var errorMessage: String?
    
    
    var rootRef: DatabaseReference = DatabaseReference()
    
    // Handling save confirmation alert
    @State private var showingConfirmationAlert = false
    
    // Handling sign out confirmation alert
    @State private var showingSignOutAlert = false
    
    // Environment variable to dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Edita los detalles de tu cuenta")
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Apellido", text: $apellido)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Carrera", text: $carrera)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Semestre", text: $semestre)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: saveChanges) {
                Image(systemName: "square.and.arrow.down")
                Text("Guardar Cambios")
            }
            
            // Sign out button
            Spacer()
            Button(action: signOut) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                    Text("Cerrar Sesión")
                }
            }
            .alert(isPresented: $showingSignOutAlert) {
                Alert(
                    title: Text("Sesión cerrada"),
                    message: Text("La sesión ha sido cerrada"),
                    dismissButton: .default(Text("OK")) {
                        // Navigate to login view or root view after sign out
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        .padding()
        
        .alert(isPresented: $showingConfirmationAlert) {
            Alert(title: Text("Cambios guardados"), message: Text("Tus cambios han sido guardados con éxito!"), dismissButton: .default(Text("OK")))
        }
        
        HStack { // Bottom bar
            Spacer()
            NavigationLink(destination: HomeView()) {
                Image(systemName: "ticket.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.green)
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            .padding()
            
            Spacer()
        }
        .background(Color.primary)
        
        .onAppear {
            fetchUserData()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func fetchUserData() {
        let userID = Auth.auth().currentUser?.uid
        rootRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: Any] {
                username = value["username"] as? String ?? ""
                apellido = value["apellido"] as? String ?? ""
                carrera = value["carrera"] as? String ?? ""
                semestre = value["semestre"] as? String ?? ""
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    private func saveChanges() {
        guard !username.isEmpty, !apellido.isEmpty, !carrera.isEmpty, !semestre.isEmpty else {
            errorMessage = "Por favor llene todos los campos"
            return
        }
        
        let userID = Auth.auth().currentUser?.uid ?? "Unknown User"
        let userUpdates = [
            "username": username,
            "apellido": apellido,
            "carrera": carrera,
            "semestre": semestre
        ]
        rootRef.child("users").child(userID).updateChildValues(userUpdates) { error, _ in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                showingConfirmationAlert = true
                // Dismiss current view
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            appState.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

#Preview {
    ProfileView()
}
