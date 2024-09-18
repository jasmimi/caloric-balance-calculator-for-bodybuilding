//
//  SignUp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI
import FirebaseAuth

struct SignUp: View {
    @State private var blankProfile = Profile.blank
    var formFilled = true

    var body: some View {
        NavigationStack {
            Text("Tell us about you")
            ProfileEditor(profile: $blankProfile, signup: true)
            NavigationLink("Continue"){
//                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                      // ...
//                    }
                    ShareData()
            }.disabled(!formFilled)
        }
    }
}

#Preview {
    SignUp()
}
