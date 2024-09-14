//
//  DashboardHome.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI

struct DashboardHome: View {
    @Environment(ModelData.self) var modelData
    @State private var showingProfile = false
    var profile: Profile
    
    var body: some View {
        NavigationStack {
            List {
            }
            .listStyle(.inset)
            .navigationTitle("\(profile.firstName)'s \(genTitle(goal: profile.goal))")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environment(modelData)
            }
        } 
    }
    
    func genTitle(goal: String) -> String {
        var x = profile.goal
        if (x == "Maintain"){
            x = "maintenance"
        }
        return x.lowercased()
    }
}

#Preview {
    DashboardHome(profile: Profile.default)
        .environment(ModelData())
}
