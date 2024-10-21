//
//  MealEntry.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//

// Imports
import SwiftUI
import HealthKit

// View structure
struct MealEntry: View {
    
    // Initialise variables
    @Binding var meal: Meal
    @State private var date = Date()
    var healthKitStore: HKHealthStore
    
    // Add environment dismiss action
    @Environment(\.dismiss) var dismiss

    // User can input meal data from 2021 start - 2024 end
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    // Form validation
    private var isFormFilled: Bool {
        return meal.intake > 0
    }
    
    // View body
    var body: some View {
        ZStack {
            Color.indigo.ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ZStack {
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .frame(width: 350, height: UIScreen.main.bounds.height/3.5)
                
                // Form headings and input fields
                VStack {
                    Text("Log meal")
                        .bold()
                        .font(.title)
                    
                    HStack{
                        DatePicker(
                            "Date time",
                             selection: $date,
                             in: dateRange,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top)
                    
                    HStack{
                        Text("Calories Consumed")
                        Spacer()
                        Spacer()
                        TextField("Intake", value: $meal.intake, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // Submit button enabled if form validation is satisfied
                    Button("Add to meal log") {
                        addMealToHealthKit(calories: meal.intake, date: date, healthStore: healthKitStore)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormFilled)
                }
                .padding()
            }
        }
    }

    // Send meal entry data to HealthKit
    func addMealToHealthKit(calories: Double, date: Date, healthStore: HKHealthStore) {
        // 1. Define the dietary energy consumed quantity type
        guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Dietary energy consumed type is not available.")
            return
        }
        
        // 2. Ensure authorization before trying to save
        healthStore.getRequestStatusForAuthorization(toShare: [dietaryEnergyConsumedType], read: [dietaryEnergyConsumedType]) { (status, error) in
            if status == .unnecessary {
                print("Permissions have already been granted.")
            } else if status == .shouldRequest || status == .unknown {
                print("Request for permissions.")
            }

            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
                return
            }
            
            // 3. Create the HKQuantity to represent the energy consumed (in kilocalories)
            let energyConsumedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
            
            // 4. Create the HKQuantitySample to store the energy consumed and the date/time
            let energyConsumedSample = HKQuantitySample(type: dietaryEnergyConsumedType, quantity: energyConsumedQuantity, start: date, end: date)
            
            // 5. Save the sample to HealthKit
            healthStore.save(energyConsumedSample) { success, error in
                if success {
                    print("Successfully saved dietary energy consumed to HealthKit!")
                    dismiss()  // Dismiss the sheet upon success
                } else if let error = error {
                    print("Error saving dietary energy consumed: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    MealEntry(meal: .constant(Meal.default), healthKitStore: HKHealthStore())
        .environmentObject(ModelData())
}
