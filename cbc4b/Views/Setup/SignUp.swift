//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUp: View {
    @State private var blankProfile = Profile.blank
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignedUp: Bool = false // Tracks successful sign-up to navigate
    @State private var uid: String? = nil // Store the UID

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
                        .padding(.bottom)
                }

                // Sign-up button
                Button(action: {
                    signUpUserSignIn()
                }) {
                    Text("Continue")
                }
                .disabled(!isFormFilled) // Disable if form is not filled
            }
            .navigationDestination(isPresented: $isSignedUp) {
                if let uid = uid {
                    ShareData(atitle: uid) 
                } else {
                    Text("Error: UID not found")
                }
            }

        }
    }

    private func signUpUserSignIn() {
        Auth.auth().createUser(withEmail: blankProfile.email, password: blankProfile.password) { authResult, error in
            if let error = error {
                // Handle Firebase Auth error, show message
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }

            // Successful sign-up, proceed to sign in
            guard let uid = authResult?.user.uid else {
                print("Unable to retrieve user ID")
                self.errorMessage = "Unable to retrieve user ID"
                self.showError = true
                return
            }

            self.uid = uid
            self.showError = false
            
            // Sign in the user automatically
            Auth.auth().signIn(withEmail: blankProfile.email, password: blankProfile.password) { authResult, error in
                if let error = error {
                    // Handle sign-in error
                    print("Sign-in failed: \(error.localizedDescription)")
                    self.errorMessage = "Sign-in failed: \(error.localizedDescription)"
                    self.showError = true
                    return
                }
                
                // Save additional user data to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(self.uid!).setData([
                    "firstName": self.blankProfile.firstName,
                    "lastName": self.blankProfile.lastName,
                    "age": self.blankProfile.age,
                    "height": self.blankProfile.height,
                    "weight": self.blankProfile.weight,
                    "sex": self.blankProfile.sex,
                    "fitnessActivityLevel": self.blankProfile.fitnessActivityLevel,
                    "goal": self.blankProfile.goal,
                    "notifications": self.blankProfile.prefersNotifications
                ]) { err in
                    if let err = err {
                        print("Error saving user data: \(err.localizedDescription)")
                        self.errorMessage = "Error saving user data: \(err.localizedDescription)"
                        self.showError = true
                    } else {
                        // Data successfully saved, navigate to the next screen
                        self.isSignedUp = true
                    }
                }
            }
        }
    }
}

#Preview {
    SignUp()
}
