//
//  ShareData.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 14/09/2024.
//

// Imports
import SwiftUI
import HealthKit

// View structure
struct ShareData: View {
    
    // Initalise variables
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

    // View body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                ZStack(alignment: .bottomLeading) {
                    Color.indigo
                        .frame(width: .infinity, height: UIScreen.main.bounds.height / 5 * 3)
                        .ignoresSafeArea()

                    VStack {
                        Spacer()
                        
                        // Share data title
                        Text("Share your data")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0)) 
                    }
                }
                ZStack (alignment: .top) {
                    Color.white
                        .frame(width: .infinity, height: UIScreen.main.bounds.height/5*2)
                    VStack {
                        
                        // Toggle to bring up iOS share data write/read
                        Toggle(isOn: $appleHealthToggle) {
                            Text("Apple Health data")
                        }
                        .onChange(of: appleHealthToggle){ newValue in
                            if newValue {
                                requestHealthKitAccess()
                            }
                        }
                        
                        // Continue button if data is shared
                        Button(action: {
                            if appleHealthToggle {
                                authManager.markShareDataComplete()
                            }
                        }) {
                            Text("Continue")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .disabled(!appleHealthToggle)

                        // Warning message to user to enable toggle
                        if !(appleHealthToggle) {
                            Text("Please enable toggle to continue")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    ShareData(atitle: "Tc2nvjU9gDgbCyF5eNBhGMDnFG72")
}
