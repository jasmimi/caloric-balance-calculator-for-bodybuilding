//
//  ExerciseEntry.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//
import SwiftUI
import HealthKit

struct ExerciseEntry: View {
    @Binding var exercise: Exercise
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
        return exercise.expenditure > 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Log exercise")
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
                Text("Calories Burned")
                Spacer()
                Spacer()
                TextField("Expenditure", value: $exercise.expenditure, formatter: NumberFormatter())
            }
            
            Button("Add to meal log") {
                addExerciseToHealthKit(calories: exercise.expenditure, date: date, healthStore: healthKitStore)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormFilled)
        }
        .padding()
    }
    
    func addExerciseToHealthKit(calories: Double, date: Date, healthStore: HKHealthStore) {
        // 1. Define the dietary energy consumed quantity type
        guard let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Dietary energy consumed type is not available.")
            return
        }
        
        // 2. Create the HKQuantity to represent the energy consumed (in kilocalories)
        let energyBurnedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
        
        // 3. Create the HKQuantitySample to store the energy consumed and the date/time
        let energyBurnedSample = HKQuantitySample(type: activeEnergyBurnedType, quantity: energyBurnedQuantity, start: date, end: date)
        
        // 4. Save the sample to HealthKit
        healthStore.save(energyBurnedSample) { success, error in
            if success {
                print("Successfully saved active energy burned to HealthKit!")
                dismiss()  // Dismiss the sheet upon success
            } else if let error = error {
                print("Error saving active energy burned: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ExerciseEntry(exercise: .constant(Exercise.default), healthKitStore: HKHealthStore())
        .environmentObject(ModelData())
}
