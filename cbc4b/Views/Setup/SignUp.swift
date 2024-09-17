//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI

struct SignUp: View {
    @State private var blankProfile = Profile.blank
    var formFilled = true

    var body: some View {
        NavigationStack {
            Text("Tell us about you")
            ProfileEditor(profile: $blankProfile)
            NavigationLink("Continue"){
                if formFilled {
                    ShareData()
                }
            }
        }
    }
}

#Preview {
    SignUp()
}
