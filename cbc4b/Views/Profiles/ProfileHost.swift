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
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = draftProfile
                    }
            }
        }
        .padding()
        Button("Sign Out") {
            authManager.signOut { error in
                if let error = error {
                    print("Sign-out error: \(error.localizedDescription)")
                    // Show error
                }
            }
        }
    }
}


#Preview {
    ProfileHost()
        .environmentObject(ModelData())
}

