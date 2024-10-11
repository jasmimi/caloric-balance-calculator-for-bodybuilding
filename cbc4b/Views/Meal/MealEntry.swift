//
//  MealEntry.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//
import SwiftUI
import HealthKit

struct MealEntry: View {
    @Binding var meal: Meal
    @State private var date = Date()
    var healthKitStore: HKHealthStore
    
    // Add environment dismiss action
    @Environment(\.dismiss) var dismiss

    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    private var isFormFilled: Bool {
        return meal.intake > 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            HStack{
                Text("Calories Consumed")
                Spacer()
                Spacer()
                TextField("Intake", value: $meal.intake, formatter: NumberFormatter())
            }
            
            Button("Add to meal log") {
                addMealToHealthKit(calories: meal.intake, date: date, healthStore: healthKitStore)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormFilled)
        }
        .padding()
    }
    
    func addMealToHealthKit(calories: Double, date: Date, healthStore: HKHealthStore) {
        // 1. Define the dietary energy consumed quantity type
        guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Dietary energy consumed type is not available.")
            return
        }
        
        // 2. Create the HKQuantity to represent the energy consumed (in kilocalories)
        let energyConsumedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
        
        // 3. Create the HKQuantitySample to store the energy consumed and the date/time
        let energyConsumedSample = HKQuantitySample(type: dietaryEnergyConsumedType, quantity: energyConsumedQuantity, start: date, end: date)
        
        // 4. Save the sample to HealthKit
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

#Preview {
    MealEntry(meal: .constant(Meal.default), healthKitStore: HKHealthStore())
        .environmentObject(ModelData())
}
