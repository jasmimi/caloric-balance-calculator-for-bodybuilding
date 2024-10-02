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
    
    func fetchCaloricExpenditureForToday(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        guard let CaloricExpendType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Active Energy Burned is no longer available ***")
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
        let expenditureQuery = HKStatisticsCollectionQuery(
            quantityType: CaloricExpendType,
            quantitySamplePredicate: thisWeekPredicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: dailyInterval
        )
        
        // Handle the results
        expenditureQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("*** Error fetching caloric expenditure: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            completion(statisticsCollection)
        }
        
        // Run a long-running query that updates its statistics as new data comes in.
        let updateQueue = expenditureQuery.results(for: healthStore)


        // Wait for the initial results and updates.
        updateTask = Task {
            for try await results in updateQueue {
                // Use the statistics collection here.
            }
        }

    }
    
    func fetchCaloricIntakeForToday(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
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

    }
    
    // Function to fetch daily step counts for the past 7 days
    func fetchStepCountForThisWeek(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        // Define the quantity type for step count
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Step Count Type is no longer available ***")
        }
        
        // Create a predicate for this week's samples
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past 7 days
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today),
              let startDate = calendar.date(byAdding: .day, value: -7, to: today) else {
            fatalError("*** Unable to calculate the start or end date ***")
        }
        
        let thisWeekPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Set up a daily interval
        let dailyInterval = DateComponents(day: 1)
        
        // Define the anchor date as the start of the day
        let anchorDate = calendar.startOfDay(for: today)
        
        // Create the statistics query for cumulative sum of steps
        let stepsQuery = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: thisWeekPredicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: dailyInterval
        )
        
        // Handle the results
        stepsQuery.initialResultsHandler = { query, statisticsCollection, error in
            if let error = error {
                print("*** Error fetching step count: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            completion(statisticsCollection)
        }
        
        // Execute the query
        healthStore.execute(stepsQuery)
    }
}
