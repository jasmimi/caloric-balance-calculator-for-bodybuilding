//
//  ExerciseList.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

// Imports
import SwiftUI
import HealthKit

// View structure
struct ExerciseList: View {
    
    // Initialise variables
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @State private var showingExerciseEntry = false
    @State private var caloricExpenditure: [(date: Date, time: Date, calories: Double)]? = nil
    @State private var newExercise = Exercise(date: Date(), time: Date(), expenditure: 0.0)
    var healthKitStore: HealthKitStore
    
    // Format date for readable list display
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // View body
    var body: some View {
        NavigationStack {
            List {
                
                // Error handling for HealthKit access
                if HKHealthStore.isHealthDataAvailable() {
                    
                    // Sort by recent, displays date, time, and calories
                    if let expenditure = caloricExpenditure {
                        ForEach(expenditure.prefix(30).reversed(), id: \.date) { entry in
                            VStack(alignment: .leading) {
                                Text("Date: \(dateFormatter.string(from: entry.date))")
                                Text("Time: \(dateFormatter.string(from: entry.time))")
                                Text("Calories: \(entry.calories, specifier: "%.2f") kcal")
                            }
                        }
                    } else {
                        Text("No data available")
                    }
                } else {
                    Text("Health data not available")
                }
            }
            .listStyle(.inset)
            .navigationTitle("Exercise log")
            .toolbar {
                Button {
                    showingExerciseEntry.toggle()
                } label: {
                    Label("Add Exercise", systemImage: "plus.app")
                }
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
            .sheet(isPresented: $showingExerciseEntry) {
                ExerciseEntry(exercise: $newExercise, healthKitStore: HKHealthStore())
                    .onDisappear {
                        
                    // Add the new exercise to the caloricOuttake array when the sheet is dismissed
                        if newExercise.expenditure > 0 {
                            caloricExpenditure?.append((date: newExercise.date, time: newExercise.time, calories: newExercise.expenditure))
                            caloricExpenditure = caloricExpenditure?.sorted { $0.date > $1.date } // Sort by date if needed
                        }
                    }
            }
        }
        .onAppear {
            fetchCaloricExpenditure() // Fetch the caloric expenditure when the view appears
        }
    }
    
    // Get from HK instance
    func fetchCaloricExpenditure() {
        healthKitStore.fetchCaloricExpenditureForWeekLog{ calories in
            DispatchQueue.main.async {
                self.caloricExpenditure = calories
            }
        }
    }
}

#Preview {
    ExerciseList(healthKitStore: HealthKitStore.shared) // Replace with a valid instance
        .environmentObject(ModelData())
}
