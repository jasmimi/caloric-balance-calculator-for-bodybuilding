//
//  ContentView.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 20/08/2024.
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var signedIn = false
    @EnvironmentObject var modelData: ModelData
    // Store the listener handle if needed to remove it later
    @State private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    var body: some View {
        VStack {
            if signedIn {
                AuthNavTabs()
            } else {
                Start()
            }
        }
        .onAppear {
            print("Signing out for testing purposes...")
            do {
                try Auth.auth().signOut()  // Ensure no cached user exists
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }

            // Use Firebase's AuthStateDidChangeListener to observe authentication state changes
            authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    print("User signed in: \(user.uid)")
                    signedIn = true
                } else {
                    print("No user signed in")
                    signedIn = false
                }
            }
        }
        .onDisappear {
            // Optionally remove the listener when the view disappears
            if let handle = authStateListenerHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}

