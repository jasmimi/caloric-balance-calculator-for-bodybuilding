//
//  MealList.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

// Imports
import SwiftUI
import HealthKit

// View structure
struct MealList: View {
    
    // Initialise variables
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @State private var showingMealEntry = false
    @State private var caloricIntake: [(date: Date, time: Date, calories: Double)]? = nil
    @State private var newMeal = Meal(date: Date(), time: Date(), intake: 0)
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
                    if let intake = caloricIntake {
                        ForEach(intake.reversed(), id: \.date) { entry in
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
            .navigationTitle("Meal log")
            .toolbar {
                Button {
                    showingMealEntry.toggle()
                } label: {
                    Label("Add Meal", systemImage: "plus.app")
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
            .sheet(isPresented: $showingMealEntry) {
                MealEntry(meal: $newMeal, healthKitStore: HKHealthStore())
                    .onDisappear {
                        
                    // Add the new meal to the caloricIntake array when the sheet is dismissed
                    if newMeal.intake > 0 {
                        caloricIntake?.append((date: newMeal.date, time: newMeal.time, calories: newMeal.intake))
                        caloricIntake = caloricIntake?.sorted { $0.date > $1.date } // Sort by date if needed
                    }
                }
            }
        }
        .onAppear {
            fetchCaloricIntake() // Fetch the caloric intake when the view appears
        }
    }
    
    // Get from HK instance
    func fetchCaloricIntake() {
        healthKitStore.fetchCaloricIntakeForWeekLog { calories in
            DispatchQueue.main.async {
                self.caloricIntake = calories
            }
        }
    }
}

#Preview {
    MealList(healthKitStore: HealthKitStore.shared)
        .environmentObject(ModelData())
}
