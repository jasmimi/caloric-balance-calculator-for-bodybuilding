//
//  ProfileEditor.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

// Imports
import SwiftUI

// View structure
struct ProfileEditor: View {
    
    // Initialise variables
    @Binding var profile: Profile
    var signup = false
    
    // View body
    var body: some View {
        List {
            
            // For signing up screen: email edit
            if signup {
                HStack {
                    Text("Email")
                    Spacer()
                    TextField("Email", text: $profile.email)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                        .disabled(!signup)
                }
            }
            
            // For signing up screen: password edit
            if signup {
                HStack {
                    Text("Password")
                    Spacer()
                        TextField("Password", text: $profile.password, prompt: Text("8 chars, 1 cap, 1 num"))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.trailing)
                }
            }
            
            // First name entry field and label
            HStack {
                Text("First name")
                Spacer()
                TextField("Firstname", text: $profile.firstName)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            // Last name entry field and label
            HStack {
                Text("Last name")
                Spacer()
                TextField("Lastname", text: $profile.lastName)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            // Notifications toggle and label
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
            }
            
            // Age entry field and label
            HStack {
                Text("Age")
                Spacer()
                TextField("Age", value: $profile.age, formatter: NumberFormatter())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            // Height picker and label
            Picker("Height", selection: $profile.height) {
                ForEach(Profile.Height.allCases) { height in
                    Text(height.rawValue).tag(height)
                }
            }
            
            // Weight entry field and label
            HStack {
                Text("Weight")
                Spacer()
                TextField("weight", value: $profile.weight, formatter: NumberFormatter())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            // Sex picker and label
            Picker("Sex", selection: $profile.sex) {
                ForEach(Profile.Sex.allCases) { sex in
                    Text(sex.rawValue).tag(sex)
                }
            }
            
            // Fitness activity picker and label
            Picker("Fitness activity level", selection: $profile.fitnessActivityLevel) {
                ForEach(Profile.FitnessActivityLevel.allCases) { fan in
                    Text(fan.rawValue).tag(fan)
                }
            }
            .frame(height: 60)
            
            // Goal picker and label
            VStack {
                Text("Goal")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("Goal", selection: $profile.goal) {
                    ForEach(Profile.Goal.allCases) { goal in
                        Text(goal.rawValue).tag(goal)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
            }
        }
    }
}


#Preview {
    ProfileEditor(profile: .constant(.default), signup: false)
}
