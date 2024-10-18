//
//  ProfileHost.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

// Imports
import SwiftUI

// View structure
struct ProfileHost: View {
    
    // Initialise variables
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var authManager: AuthManager
    @State private var draftProfile = Profile.default

    // View body
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Call profile summary/view
                ProfileSummary(profile: modelData.profile)
            }
            .onAppear{
                if let uid = authManager.currentUserUID {
                    modelData.loadProfile(uid: uid)
                }
            }
            .padding()
            
            // Sign out button
            Button("Sign Out") {
                authManager.signOut { error in
                    if let error = error {
                        print("Sign-out error: \(error.localizedDescription)")
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    ProfileHost()
        .environmentObject(ModelData())
}
