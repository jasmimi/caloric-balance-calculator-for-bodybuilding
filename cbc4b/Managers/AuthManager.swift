//
//  AuthManager.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 27/09/2024.
//

// Imports
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Class to behave as Objective-C object and Observer object/pattern
class AuthManager: NSObject, ObservableObject {
    
    // Shared singleton instance
    static let shared = AuthManager()
    
    // State variables for entry app navigation
    @Published var isUserLoggedIn = false
    @Published var shouldNavigateToShareData = false
    @Published var hasCompletedShareData = false 

    // Private initialisation for singleton
    private override init() {
        super.init()
        setupAuthStateChangeListener()
    }

    // Function checks whether a user iss logged in and has shared data
    private func setupAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let user = user {
                    self.isUserLoggedIn = true
                    self.checkShareDataCompletion(for: user.uid)
                } else {
                    self.isUserLoggedIn = false
                    self.hasCompletedShareData = false
                }
            }
        }
    }
    
    // Checks FB FS Users collection record for users data sharing completion
    private func checkShareDataCompletion(for uid: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.hasCompletedShareData = data?["hasCompletedShareData"] as? Bool ?? false
            } else {
                print("User document does not exist")
                self.hasCompletedShareData = false
            }
        }
    }
    
    // Once user shares data, writes to relevant Users collection record to remember
    func markShareDataComplete() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData(["hasCompletedShareData": true]) { error in
            if let error = error {
                print("Error updating ShareData status: \(error)")
            } else {
                self.hasCompletedShareData = true
            }
        }
    }

    // Handles user sign out
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }
}

extension AuthManager {
    
    // Get current users UID
    var currentUserUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // Create FB authenticated account with entered email and password strings
    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    // Sign in authenticated user with entered email and password strings
    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
