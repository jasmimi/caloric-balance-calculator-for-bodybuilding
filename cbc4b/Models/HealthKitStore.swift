//
//  HealthKitStore.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 03/10/2024.
//
import Foundation
import HealthKit

class HealthKitStore {
    
    let healthStore = HKHealthStore()
    
    func fetchCaloricExpenditureForToday(completion: @escaping (Double?) -> Void) {
        
        guard let caloricExpendType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Active Energy Burned is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for today
        let startDate = today
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Create the statistics query for cumulative sum of active energy burned
        let expenditureQuery = HKStatisticsQuery(quantityType: caloricExpendType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            if let error = error {
                print("*** Error fetching caloric expenditure: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            // Get the total calories burned
            let totalCalories = result?.sumQuantity()?.doubleValue(for: .largeCalorie())
            completion(totalCalories)
        }
        
        // Execute the query
        healthStore.execute(expenditureQuery)
    }
    
    func fetchCaloricIntakeForToday(completion: @escaping (Double?) -> Void) {
        
        guard let CaloricIntakeType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("*** Dietary Energy Consumed is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for today
        let startDate = today
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Create the statistics query for cumulative sum of active energy burned
        let intakeQuery = HKStatisticsQuery(quantityType: CaloricIntakeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            if let error = error {
                print("*** Error fetching caloric intake: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            // Get the total calories intake
            let totalCalories = result?.sumQuantity()?.doubleValue(for: .largeCalorie())
            completion(totalCalories)
        }
        
        // Execute the query
        healthStore.execute(intakeQuery)
    }
    
    /*func fetchCaloricIntakeForToday(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        guard let CaloricIntakeType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("*** Dietary Energy Consumed is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past 7 days
        guard let startDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("*** Unable to calculate the start/end date ***")
        }
        
        let thisWeekPredicate = HKQuery.predicateForSamples(withStart: startDate, end: startDate, options: .strictStartDate)

        // Set up a daily interval
        let dailyInterval = DateComponents(day: 1)
        
        // Define the anchor date as the start of the day
        let anchorDate = calendar.startOfDay(for: today)
        
        // Create the statistics query for cumulative sum of steps
        let intakeQuery = HKStatisticsCollectionQuery(
            quantityType: CaloricIntakeType,
            quantitySamplePredicate: thisWeekPredicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: dailyInterval
        )
        
        // Handle the results
        intakeQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("*** Error fetching caloric intake: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            completion(statisticsCollection)
        }
        
        // Run a long-running query that updates its statistics as new data comes in.
        let updateQueue = intakeQuery.results(for: healthStore)


        // Wait for the initial results and updates.
        updateTask = Task {
            for try await results in updateQueue {
                // Use the statistics collection here.
            }
        }

    }*/
}
