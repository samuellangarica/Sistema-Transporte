//
//  SignupView.swift
//  iOSApp
//
//  Created by Samuel Langarica on 02/05/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SignupView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var email = ""
    @State private var username = ""
    @State private var apellido = ""
    @State private var carrera = ""
    @State private var semestre = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        ScrollView {
            VStack {
                Text("Crear Cuenta")
                    .font(.title)
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Correo", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Usuario", text: $username)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Apellido", text: $apellido)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Carrera", text: $carrera)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    TextField("Semestre", text: $semestre)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    SecureField("Confirmar contraseña", text: $confirmPassword)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Button(action: signUp) {
                        Text("Crear Cuenta")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        }
    }

    func signUp() {
        guard !email.isEmpty, !username.isEmpty, !apellido.isEmpty, !carrera.isEmpty, !semestre.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Por favor llene todos los campos"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let authResult = authResult {
                let newUser = [
                    "email": email,
                    "username": username,
                    "apellido": apellido,
                    "carrera": carrera,
                    "semestre": semestre
                ]
                let usersRef = Database.database().reference().child("users")
                usersRef.child(authResult.user.uid).setValue(newUser) { error, _ in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        appState.signIn()
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
