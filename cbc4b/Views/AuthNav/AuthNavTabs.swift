//
//  AuthNavTabs.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 18/09/2024.
//

import SwiftUI

struct AuthNavTabs: View {
    @State private var selection: Tab = .dashboard

    enum Tab {
        case dashboard
        case meal
        case exercise
    }
    
    var body: some View {
        TabView(selection: $selection) {
            DashboardHome(profile: Profile.default, healthKitStore: HealthKitStore.init())
                .tabItem {
                    Label("Dashboard", systemImage: "brain.head.profile")
                }
                .tag(Tab.dashboard)
            
            MealList(healthKitStore: HealthKitStore.init())
                .tabItem {
                    Label("Meal", systemImage: "carrot")
                }
                .tag(Tab.meal)
            
            ExerciseList(healthKitStore: HealthKitStore.init())
                .tabItem {
                    Label("Exercise", systemImage: "figure.run.circle")
                }
                .tag(Tab.exercise)
        }    }
}

#Preview {
    AuthNavTabs()
        .environmentObject(ModelData())
}
