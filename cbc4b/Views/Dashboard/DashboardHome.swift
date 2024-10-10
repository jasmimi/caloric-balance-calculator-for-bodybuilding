//
//  DashboardHome.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI
import Foundation
import HealthKit

struct DashboardHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @State private var caloricExpenditure: Double? = nil  // State variable to store fetched data
    @State private var caloricIntake: Double? = nil  // State variable to store fetched data
    var profile: Profile
    var healthKitStore: HealthKitStore

    var body: some View {
        NavigationStack {
            List {
                if HKHealthStore.isHealthDataAvailable() {
                    
                    // Daily caloric expenditure
                    if let caloriesExp = caloricExpenditure {
                        Text("Calories Burned Today: \(String(format: "%.0f", caloriesExp)) kcal") // Display the calories as an integer
                        
                    } else {
                        Text("Fetching Caloric Expenditure...")
                    }
                    
                    // Daily caloric intake
                    if let caloriesInt = caloricIntake {
                        Text("Calories Consumed Today: \(String(format: "%.0f", caloriesInt)) kcal") // Display the calories as an integer
                        
                    } else {
                        Text("Fetching Caloric Intake...")
                    }
                    
                    // Daily caloric balance
                    if let caloriesExp = caloricExpenditure, let caloriesInt = caloricIntake {
                        Text("Daily Caloric Balance: \(String(format: "%.0f", caloriesInt - caloriesExp)) kcal")
                    } else {
                        Text("Fetching Caloric Balance...")
                    }
                    

                    
                } else {
                    Text("Health data not available")
                }
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
            .onAppear {
                fetchCaloricExpenditure()
                fetchCaloricIntake()
            }
        }
    }
    
    func fetchCaloricExpenditure() {
        healthKitStore.fetchCaloricExpenditureForToday { calories in
            DispatchQueue.main.async {
                self.caloricExpenditure = calories // Update state variable
            }
        }
    }
    
    func fetchCaloricIntake() {
        healthKitStore.fetchCaloricIntakeForToday { calories in
            DispatchQueue.main.async {
                self.caloricIntake = calories
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
    DashboardHome(profile: Profile.default, healthKitStore: HealthKitStore.init())
        .environmentObject(ModelData())
}
