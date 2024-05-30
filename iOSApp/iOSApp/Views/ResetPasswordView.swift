//
//  ResetPasswordView.swift
//  FinalA
//
//  Created by Samuel Langarica on 30/04/24.
//

import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Text("Ingrese su correo electrónico para recuperar su contraseña.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding()

            TextField("Correo", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                resetPassword()
            }) {
                Text("Restablecer Contraseña")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Recuperar Contraseña"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Recuperar Contraseña")
    }

    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Si tu correo está registrado, recibirás un link para recuperar tu contraseña"
            }
            showingAlert = true
        }
    }
}

#Preview {
    ResetPasswordView()
}
