//
//  ProfileSummary.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

// Imports
import SwiftUI

// View structure
struct ProfileSummary: View {
    
    // Initialise variables
    @EnvironmentObject var modelData: ModelData
    var profile: Profile
    
    // View body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // Profile heading
                Text("Profile")
                    .bold()
                    .font(.title)

                // Account details display
                Text("First name: \(profile.firstName)")
                Text("Last name: \(profile.lastName)")
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                
                // Goal calories related details display
                Divider()
                Text("Age: \(String(format: "%.f", profile.age))")
                Text("Height: \(profile.height.rawValue)")
                Text("Weight: \(String(format: "%.2f", profile.weight)) kg")
                Text("Sex: \(profile.sex.rawValue)")
                Text("Fitness activity level: \(profile.fitnessActivityLevel.rawValue)")
                
                // Goal
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
