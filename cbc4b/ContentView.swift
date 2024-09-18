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
    
    var body: some View {
        VStack {
            if signedIn {
                AuthNavTabs()
            } else {
                Start()
            }
        }
        .onAppear {
            // Check if the user is already signed in
            signedIn = Auth.auth().currentUser != nil
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
