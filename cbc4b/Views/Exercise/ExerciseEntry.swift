//
//  ExerciseEntry.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//

// Imports
import SwiftUI
import HealthKit

// View structure
struct ExerciseEntry: View {
    
    // Initialise variables
    @Binding var exercise: Exercise
    @State private var date = Date()
    var healthKitStore: HKHealthStore
    
    // Add environment dismiss action
    @Environment(\.dismiss) var dismiss

    // User can input exercise data from 2021 start - 2024 end
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
        return exercise.expenditure > 0
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
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top)
                    
                    HStack{
                        Text("Calories Burned")
                        Spacer()
                        Spacer()
                        TextField("Expenditure", value: $exercise.expenditure, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    // Submit button enabled if form validation is satisfied
                    Button("Add to exercise log") {
                        addExerciseToHealthKit(calories: exercise.expenditure, date: date, healthStore: healthKitStore)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormFilled)
                }
                .padding()
            }
        }
    }
    
    // Send exercise entry data to HealthKit
    func addExerciseToHealthKit(calories: Double, date: Date, healthStore: HKHealthStore) {
        // 1. Define the active energy burned quantity type
        guard let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Active energy burned type is not available.")
            return
        }

        // 2. Ensure authorization before trying to save
        healthStore.getRequestStatusForAuthorization(toShare: [activeEnergyBurnedType], read: [activeEnergyBurnedType]) { (status, error) in
            if status == .unnecessary {
                print("Permissions have already been granted.")
            } else if status == .shouldRequest || status == .unknown {
                print("Request for permissions.")
            }

            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
                return
            }

            // 3. Create the HKQuantity to represent the energy burned
            let energyBurnedQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)

            // 4. Create the HKQuantitySample to store the energy burned
            let energyBurnedSample = HKQuantitySample(type: activeEnergyBurnedType, quantity: energyBurnedQuantity, start: date, end: date)

            // 5. Save the sample to HealthKit
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

}

#Preview {
    ExerciseEntry(exercise: .constant(Exercise.default), healthKitStore: HKHealthStore())
        .environmentObject(ModelData())
}
