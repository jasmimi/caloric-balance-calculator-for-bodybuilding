//
//  ShareData.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

import SwiftUI
import HealthKit

struct ShareData: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var appleHealthToggle = false
    @State private var showAlert = false
    var atitle: String
    
    let healthStore = HKHealthStore()
    
    // Function to request permission for HealthKit data
    private func requestHealthKitAccess() {
        // Safely unwrap the HKObjectTypes
        if let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
           let dietaryEnergyConsumed = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
            
            let allTypes: Set<HKObjectType> = [activeEnergyBurned,
                                               HKObjectType.workoutType(),
                                               dietaryEnergyConsumed]
            
            healthStore.requestAuthorization(toShare: [], read: allTypes) { success, error in
                if !success {
                    print("HealthKit authorization failed: \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            print("Failed to unwrap HKObjectTypes.")
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Share your data")
                    .font(.headline)
                
                Toggle(isOn: $appleHealthToggle) {
                    Text("Apple Health data")
                }
                .onChange(of: appleHealthToggle) { value in
                    if value {
                        requestHealthKitAccess()
                    }
                }
                
                NavigationLink("Continue") {
                     ContentView()
                         .onAppear {
                             if appleHealthToggle {
                                 authManager.markShareDataComplete()
                             }
                         }
                 }
                .disabled(!(appleHealthToggle))
                .padding()
                
                if !(appleHealthToggle) {
                    Text("Please enable toggle to continue")
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
