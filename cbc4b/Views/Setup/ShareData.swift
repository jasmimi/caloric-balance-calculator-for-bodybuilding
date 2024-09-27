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
    @State private var showAlert = false
    var atitle: String

    var body: some View {
        NavigationStack {
            VStack {
                Text("Share your data")
                    .font(.headline)
                
                Toggle(isOn: $appleHealthToggle) {
                    Text("Apple Health data")
                }
                Toggle(isOn: $myFitnessPalToggle) {
                    Text("MyFitnessPal data")
                }
                
                NavigationLink("Continue") {
                    ContentView()
                }
                .disabled(!(appleHealthToggle && myFitnessPalToggle))
                .padding()
                
                if !(appleHealthToggle && myFitnessPalToggle) {
                    Text("Please enable both toggles to continue")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
}


#Preview {
    ShareData(atitle: "Tc2nvjU9gDgbCyF5eNBhGMDnFG72")
}
