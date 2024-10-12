//
//  Meal.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//
import Foundation

struct Meal {
    var date: Date
    var time: Date
    var intake: Double
    
    static let `default` = Meal(
        date: Date(),    // Use Date() for the default date value
        time: Date(),    // Keep the current time as default
        intake: 0.0      // Default to 0 for intake
    )
}
