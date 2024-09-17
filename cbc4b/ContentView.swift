//
//  ContentView.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 20/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .dashboard
    var signedIn = false
    
    enum Tab {
        case dashboard
        case meal
        case exercise
    }
    
    var body: some View {
        if signedIn {
            TabView(selection: $selection) {
                DashboardHome(profile: Profile.default)
                    .tabItem {
                        Label("Dashboard", systemImage: "brain.head.profile")
                    }
                    .tag(Tab.dashboard)
                
                MealList()
                    .tabItem {
                        Label("Meal", systemImage: "carrot")
                    }
                    .tag(Tab.meal)
                
                ExerciseList()
                    .tabItem {
                        Label("Exercise", systemImage: "figure.run.circle")
                    }
                    .tag(Tab.exercise)
            }
        } else {
            Start()
        }
        
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
