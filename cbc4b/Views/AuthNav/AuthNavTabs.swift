//
//  AuthNavTabs.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 18/09/2024.
//

// Imports
import SwiftUI

// View structure
struct AuthNavTabs: View {
    @State private var selection: Tab = .dashboard // Starts on dashboard

    // 3 tab options
    enum Tab {
        case dashboard
        case meal
        case exercise
    }
    
    // View body
    var body: some View {
        
        // Tab view with 3 tab options
        TabView(selection: $selection) {
            DashboardHome(profile: Profile.default, healthKitStore: HealthKitStore.shared)
                .tabItem {
                    Label("Dashboard", systemImage: "brain.head.profile")
                }
                .tag(Tab.dashboard)
            
            MealList(healthKitStore: HealthKitStore.shared)
                .tabItem {
                    Label("Meal", systemImage: "carrot")
                }
                .tag(Tab.meal)
            
            ExerciseList(healthKitStore: HealthKitStore.shared)
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
