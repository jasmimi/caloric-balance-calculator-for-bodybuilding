//
//  ExerciseList.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import SwiftUI
import HealthKit


struct ExerciseList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @State private var showingExerciseEntry = false
    @State private var caloricExpenditure: [(date: Date, time: Date, calories: Double)]? = nil
    @State private var newExercise = Exercise(date: Date(), time: Date(), expenditure: 0.0) // Add a state to hold a new Meal
    var healthKitStore: HealthKitStore
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                if HKHealthStore.isHealthDataAvailable() {
                    if let expenditure = caloricExpenditure {
                        ForEach(expenditure.reversed(), id: \.date) { entry in
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
            }
        }
        .onAppear {
            fetchCaloricExpenditure()
        }
    }
    
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
