//
//  ProfileHost.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//
import SwiftUI


struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var authManager: AuthManager
    @State private var draftProfile = Profile.default

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                ProfileSummary(profile: modelData.profile)
            }
            .onAppear{
                if let uid = authManager.currentUserUID {
                    modelData.loadProfile(uid: uid)
                }
            }
            .padding()
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
