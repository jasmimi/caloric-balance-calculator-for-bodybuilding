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
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack {
            if authManager.isUserLoggedIn {
                AuthNavTabs()
                    .environmentObject(authManager)
            } else {
                Start()
                    .environmentObject(authManager)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}

