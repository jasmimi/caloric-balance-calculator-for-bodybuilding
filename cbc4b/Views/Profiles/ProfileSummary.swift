//
//  ProfileSummary.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI

struct ProfileSummary: View {
    @EnvironmentObject var modelData: ModelData
    var profile: Profile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Profile")
                    .bold()
                    .font(.title)

                Text("First name: \(profile.firstName)")
                Text("Last name: \(profile.lastName)")
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                
                Divider()
                
                Text("Age: \(String(format: "%.f", profile.age))")
                Text("Height: \(profile.height.rawValue)")
                Text("Weight: \(String(format: "%.2f", profile.weight)) kg")
                Text("Sex: \(profile.sex.rawValue)")
                Text("Fitness activity level: \(profile.fitnessActivityLevel.rawValue)")
                
                Divider()
                Text("Goal: \(profile.goal.rawValue)")
            }
        }
    }
}

#Preview {
    ProfileSummary(profile: Profile.default)
        .environmentObject(ModelData())
}
