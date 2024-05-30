//
//  Login.swift
//  FinalA
//
//  Created by Samuel Langarica on 30/04/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var appState: AppState

    @State var email: String
    @State var password: String
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Por favor inicia sesión para continuar.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding()

                TextField("Correo", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Contraseña", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            alertMessage = "Credenciales Inválidas"
                            showingAlert = true
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            appState.signIn()
                        }
                    }
                }) {
                    Text("Iniciar Sesión")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                NavigationLink(destination: HomeView(), isActive: $appState.isAuthenticated) {
                    EmptyView()
                }
                

                HStack {
                    VStack {
                        Divider()
                    }
                    Text("o")
                        .foregroundColor(.gray)
                    VStack {
                        Divider()
                    }
                }

                NavigationLink(destination: SignupView()) {
                    Text("Crear Cuenta")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Recuperar contraseña")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Iniciar Sesión")
        }
    }
}

#Preview {
    LoginView(email: "", password: "")
}
