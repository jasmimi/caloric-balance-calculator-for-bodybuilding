//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI
import FirebaseAuth

struct SignUp: View {
    @State private var blankProfile = Profile.blank
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    private var isFormFilled: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return !blankProfile.firstName.isEmpty &&
            !blankProfile.lastName.isEmpty &&
            !blankProfile.email.isEmpty &&
            !blankProfile.password.isEmpty &&
            blankProfile.age > 0 &&
            blankProfile.age < 100 &&
            blankProfile.weight > 0 &&
            blankProfile.weight < 200 &&
            blankProfile.height != .unspecified &&
            blankProfile.sex != .unspecified &&
            blankProfile.fitnessActivityLevel != .unspecified &&
            blankProfile.goal != .unspecified &&
            emailTest.evaluate(with: blankProfile.email) &&
            passwordTest.evaluate(with: blankProfile.password)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Tell us about you")
                ProfileEditor(profile: $blankProfile, signup: true)
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                NavigationLink("Continue"){
                    ShareData()
                }.disabled(!isFormFilled)
                    .padding()
            }
        }
    }
    
    // Sign up user with Firebase
    private func signUpUser() {
        Auth.auth().createUser(withEmail: blankProfile.email, password: blankProfile.password) { authResult, error in
            if let error = error {
                // Handle error, e.g., show a message
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                // Proceed to the next step if successful
                self.showError = false
                // Navigate to ShareData screen
                // You can set up additional navigation or logic here
            }
        }
    }
}

#Preview {
    SignUp()
}
