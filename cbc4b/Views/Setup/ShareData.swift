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
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }
        
        // Safely unwrap the HKObjectTypes
        if let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
           let dietaryEnergyConsumed = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
            
            let readTypes: Set<HKObjectType> = [activeEnergyBurned,
                                                dietaryEnergyConsumed]
            
            // Add types to share (write) here
            let writeTypes: Set<HKSampleType> = [activeEnergyBurned,
                                                 dietaryEnergyConsumed]
            
            // Request both read and write permissions
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
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
                .onChange(of: appleHealthToggle){ newValue in
                    if newValue {
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
