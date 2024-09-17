//
//  ShareData.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI

struct ShareData: View {
    @State private var appleHealthToggle = false
    @State private var myFitnessPalToggle = false
    var formFilled = true

    var body: some View {
        NavigationStack {
            VStack {
                Text("Share your data")
                Toggle(isOn: $appleHealthToggle) {
                    Text("Apple Health data")
                }
                Toggle(isOn: $myFitnessPalToggle) {
                    Text("MyFitnessPal data")
                }
                NavigationLink("Continue"){
                    // need signin true authentication check
                    ContentView()
                }
            }.padding()
        }
    }
}

#Preview {
    ShareData()
}
