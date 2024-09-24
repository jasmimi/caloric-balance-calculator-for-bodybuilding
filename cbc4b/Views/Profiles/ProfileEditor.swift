//
//  ProfileEditor.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//
import SwiftUI


struct ProfileEditor: View {
    @Binding var profile: Profile
    var signup = false
    
    var body: some View {
        List {
            HStack {
                Text("Email")
                Spacer()
                TextField("Email", text: $profile.email)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
                    .disabled(!signup)
            }
            
            HStack {
                Text("Password")
                Spacer()
                if signup {
                    TextField("Password", text: $profile.password, prompt: Text("8 chars, 1 cap, 1 num"))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                } else {
                    SecureField("Password", text: $profile.password)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            HStack {
                Text("First name")
                Spacer()
                TextField("Firstname", text: $profile.firstName)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text("Last name")
                Spacer()
                TextField("Lastname", text: $profile.lastName)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
            }
            
            HStack {
                Text("Age")
                Spacer()
                TextField("Age", value: $profile.age, formatter: NumberFormatter())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            Picker("Height", selection: $profile.height) {
                ForEach(Profile.Height.allCases) { height in
                    Text(height.rawValue).tag(height)
                }
            }
            
            HStack {
                Text("Weight")
                Spacer()
                TextField("weight", value: $profile.weight, formatter: NumberFormatter())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            
            Picker("Sex", selection: $profile.sex) {
                ForEach(Profile.Sex.allCases) { sex in
                    Text(sex.rawValue).tag(sex)
                }
            }
            
            Picker("Fitness activity level", selection: $profile.fitnessActivityLevel) {
                ForEach(Profile.FitnessActivityLevel.allCases) { fan in
                    Text(fan.rawValue).tag(fan)
                }
            }
            .frame(height: 60)
            
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
