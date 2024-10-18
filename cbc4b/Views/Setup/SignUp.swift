//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

// Imports
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// View structure
struct SignUp: View {
    
    // Initialise variables
    @State private var blankProfile = Profile.blank
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignedUp: Bool = false 
    @State private var uid: String? = nil
    @EnvironmentObject var authManager: AuthManager
    private var bmr: Double = 0

    // Form validation
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

    // View body
    var body: some View {
        NavigationStack {
            VStack {
                
                // Load profile input fields (blank) and labels
                ProfileEditor(profile: $blankProfile, signup: true)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom)
                }

                // Sign up button enabled with form filled satisfaction
                Button(action: {
                    signUpUser()
                }) {
                    Text("Continue")
                }
                .disabled(!isFormFilled)
            }
            .navigationTitle("Tell us about you")
            .navigationDestination(isPresented: $isSignedUp) {
                if let uid = uid {
                    ShareData(atitle: uid)
                } else {
                    Text("Error: UID not found")
                }
            }
        }
    }

    // Convert height from ft to CM for goal calories calculation
    private func convertHeightToCm() -> Double {
        let heightInFeet = blankProfile.height.rawValue // Extract height from enum
        let feet = Double(heightInFeet.split(separator: "'")[0]) ?? 0
        let inches = Double(heightInFeet.split(separator: "'")[1].replacingOccurrences(of: "\"", with: "")) ?? 0
        return (feet * 30.48) + (inches * 2.54) // Convert to cm
    }
    
    // Calculate goal calories
    private func calculateGoalCalories() -> Double {
        // Step 1: Calculate BMR
        var bmr: Double
        if self.blankProfile.sex.rawValue == "Female" {
            bmr = 10 * self.blankProfile.weight + 6.25 * convertHeightToCm() - 5 * self.blankProfile.age - 161
        } else {
            bmr = 10 * self.blankProfile.weight + 6.25 * convertHeightToCm() - 5 * self.blankProfile.age + 5
        }
        
        // Step 2: Apply activity level multiplier to calculate TDEE
        let activityMultiplier: Double
        switch self.blankProfile.fitnessActivityLevel {
        case .s:
            activityMultiplier = 1.2
        case .l:
            activityMultiplier = 1.375
        case .m:
            activityMultiplier = 1.55
        case .a:
            activityMultiplier = 1.725
        case .va:
            activityMultiplier = 1.9
        case .ea:
            activityMultiplier = 2.0
        default:
            activityMultiplier = 1.0 // If unspecified, assume sedentary
        }
        
        let tdee = bmr * activityMultiplier

        // Step 3: Adjust for goal (cut, major cut, bulk, major bulk, maintain)
        let goalCalories: Double
        switch self.blankProfile.goal {
        case .c: // Cutting goal
            goalCalories = tdee * 0.90 // Subtract 10% for cutting
        case .mc: // Major cutting goal
            goalCalories = tdee * 0.80 // Subtract 20% for major cutting
        case .b: // Bulking goal
            goalCalories = tdee * 1.1 // Add 10% for bulking
        case .mb: // Major bulking goal
            goalCalories = tdee * 1.2 // Add 20% for major bulking
        case .m: // Maintaining goal
            goalCalories = tdee
        default:
            goalCalories = tdee // Default to maintenance if goal is unspecified
        }
        
        return goalCalories
    }

    // Create authentication account and corresponding Users document with UID and form values
    private func signUpUser() {
        authManager.createAccount(withEmail: blankProfile.email, password: blankProfile.password) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }

            // Successful sign-up, proceed to sign in and retrieve the user ID
            if let user = Auth.auth().currentUser {
                self.uid = user.uid
                self.showError = false
                
                // Save additional user data to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(self.uid!).setData([
                    "firstName": self.blankProfile.firstName,
                    "lastName": self.blankProfile.lastName,
                    "age": self.blankProfile.age,
                    "height": self.blankProfile.height.rawValue,
                    "weight": self.blankProfile.weight,
                    "sex": self.blankProfile.sex.rawValue,
                    "fitnessActivityLevel": self.blankProfile.fitnessActivityLevel.rawValue,
                    "goal": self.blankProfile.goal.rawValue,
                    "notifications": self.blankProfile.prefersNotifications,
                    "goalCalories": calculateGoalCalories()
                ]) { err in
                    if let err = err {
                        self.errorMessage = "Error saving user data: \(err.localizedDescription)"
                        self.showError = true
                    } else {
                        // Data successfully saved, navigate to the next screen
                        self.isSignedUp = true
                        self.authManager.shouldNavigateToShareData = true // Set the state here
                    }
                }
            } else {
                self.errorMessage = "Unable to retrieve user ID"
                self.showError = true
            }
        }
    }
}

#Preview {
    SignUp()
}
