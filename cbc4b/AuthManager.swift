//
//  AuthManager.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 27/09/2024.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthManager: NSObject, ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var shouldNavigateToShareData = false // New property to manage navigation
    @Published var hasCompletedShareData = false // New flag to check if ShareData is done

    override init() {
        super.init()
        setupAuthStateChangeListener()
    }

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
    var currentUserUID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

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
