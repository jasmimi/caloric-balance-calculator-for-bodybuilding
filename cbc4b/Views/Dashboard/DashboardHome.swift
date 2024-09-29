//
//  DashboardHome.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI

struct DashboardHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    var profile: Profile
    
    var body: some View {
        NavigationStack {
            List {
            }
            .listStyle(.inset)
            .navigationTitle("\(profile.firstName)'s \(genTitle(goal: profile.goal.rawValue))")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        } 
    }
    
    func genTitle(goal: String) -> String {
        var x = profile.goal.rawValue
        if (x == "Maintain"){
            x = "maintenance"
        }
        return x.lowercased()
    }
}

#Preview {
    DashboardHome(profile: Profile.default)
        .environmentObject(ModelData())
}
