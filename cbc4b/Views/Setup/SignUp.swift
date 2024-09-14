//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI

struct SignUp: View {
    @State private var blankProfile = Profile.blank

    var body: some View {
        Text("Tell us about you")
        ProfileEditor(profile: $blankProfile)
        Button("Continue"){
            
        }
    }
}

#Preview {
    SignUp()
}
