//
//  HealthKitStore.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 03/10/2024.
//

// Imports
import Foundation
import HealthKit

// Class to handle HealthKit API interactions
class HealthKitStore {
    
    // Shared singleton instance and private initialisation
    static let shared = HealthKitStore()
    private init() {}
    let healthStore = HKHealthStore()
    
    // Summation of caloric expenditure for the day
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
    
    // Summation of caloric intake for the day
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

        // Create the statistics query for cumulative sum of dietary energy consumed
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
    
    // List of caloric expenditure for the past week: date, time, caloric output
    func fetchCaloricExpenditureForWeekLog(completion: @escaping ([(date: Date, time: Date, calories: Double)]?) -> Void) {
        
        guard let caloricExpendType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Active Energy Burned is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past week
        let startDate = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)  // Tomorrow's start for the end of today
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Use HKSampleQuery to fetch the samples within the date range
        let expenditureQuery = HKSampleQuery(sampleType: caloricExpendType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            
            if let error = error {
                print("*** Error fetching caloric expenditure: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            var weeklyCalories: [(date: Date, time: Date, calories: Double)] = []
            
            // Loop through the samples and extract date, time, and calories
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    let calories = sample.quantity.doubleValue(for: .largeCalorie())  // Get calories as kcal
                    let date = sample.startDate  // The date part (start of the sample)
                    let time = sample.startDate  // The time part (exact time of the sample)
                    
                    weeklyCalories.append((date: date, time: time, calories: calories))
                }
            }
            
            completion(weeklyCalories)
        }
        
        // Execute the query
        healthStore.execute(expenditureQuery)
    }
    
    // List of caloric intake for the past week: date, time, caloric input
    func fetchCaloricIntakeForWeekLog(completion: @escaping ([(date: Date, time: Date, calories: Double)]?) -> Void) {
        
        guard let caloricIntakeType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("*** Dietary Energy Consumed is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past week
        let startDate = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)  // Tomorrow's start for the end of today
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Use HKSampleQuery to fetch the samples within the date range
        let intakeQuery = HKSampleQuery(sampleType: caloricIntakeType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            
            if let error = error {
                print("*** Error fetching caloric intake: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            var weeklyCalories: [(date: Date, time: Date, calories: Double)] = []
            
            // Loop through the samples and extract date, time, and calories
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    let calories = sample.quantity.doubleValue(for: .largeCalorie())  // Get calories as kcal
                    let date = sample.startDate  // The date part (start of the sample)
                    let time = sample.startDate  // The time part (exact time of the sample)
                    
                    weeklyCalories.append((date: date, time: time, calories: calories))
                }
            }
            completion(weeklyCalories)
        }
        
        // Execute the query
        healthStore.execute(intakeQuery)
    }
    
    // Array of caloric intake daily summations for the past week
    func fetchCaloricIntakeForWeek(completion: @escaping ([Double]?) -> Void) {
        
        guard let caloricIntakeType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            fatalError("*** Dietary Energy Consumed is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past week
        let startDate = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)  // Tomorrow's start for the end of today
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Use HKSampleQuery to fetch the samples within the date range
        let intakeQuery = HKSampleQuery(sampleType: caloricIntakeType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            
            if let error = error {
                print("*** Error fetching caloric intake: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            // Create a dictionary to store total calories per day
            var dailyCalories = [Date: Double]()
            
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    let calories = sample.quantity.doubleValue(for: .largeCalorie())  // Get calories as kcal
                    let sampleDate = calendar.startOfDay(for: sample.startDate)  // Get the date part of the sample
                    
                    // Sum the calories for each day
                    dailyCalories[sampleDate, default: 0.0] += calories
                }
            }
            
            // Generate an array of daily caloric intake for the past 7 days
            var weeklyCalories: [Double] = []
            for dayOffset in 0..<7 {
                let day = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
                let dayStart = calendar.startOfDay(for: day)
                let totalCaloriesForDay = dailyCalories[dayStart] ?? 0.0
                weeklyCalories.append(totalCaloriesForDay)
            }
            
            completion(weeklyCalories.reversed())  // Reverse to start with the earliest day in the array
        }
        
        // Execute the query
        healthStore.execute(intakeQuery)
    }

    // Array of caloric expenditure daily summations for the past week
    func fetchCaloricExpenditureForWeek(completion: @escaping ([Double]?) -> Void) {
        
        guard let caloricExpenditureType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** Active Energy Burned is no longer available ***")
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        // Define start and end dates for the past week
        let startDate = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        let endDate = calendar.date(byAdding: .day, value: 1, to: today)  // Tomorrow's start for the end of today
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Use HKSampleQuery to fetch the samples within the date range
        let expenditureQuery = HKSampleQuery(sampleType: caloricExpenditureType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            
            if let error = error {
                print("*** Error fetching caloric expenditure: \(error.localizedDescription) ***")
                completion(nil)
                return
            }
            
            // Create a dictionary to store total calories per day
            var dailyCalories = [Date: Double]()
            
            if let quantitySamples = samples as? [HKQuantitySample] {
                for sample in quantitySamples {
                    let calories = sample.quantity.doubleValue(for: .largeCalorie())  // Get calories as kcal
                    let sampleDate = calendar.startOfDay(for: sample.startDate)  // Get the date part of the sample
                    
                    // Sum the calories for each day
                    dailyCalories[sampleDate, default: 0.0] += calories
                }
            }
            
            // Generate an array of daily caloric intake for the past 7 days
            var weeklyCalories: [Double] = []
            for dayOffset in 0..<7 {
                let day = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
                let dayStart = calendar.startOfDay(for: day)
                let totalCaloriesForDay = dailyCalories[dayStart] ?? 0.0
                weeklyCalories.append(totalCaloriesForDay)
            }
            
            completion(weeklyCalories.reversed())  // Reverse to start with the earliest day in the array
        }
        
        // Execute the query
        healthStore.execute(expenditureQuery)
    }
}
