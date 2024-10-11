//
//  Exercise.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 11/10/2024.
//

import Foundation

struct Exercise {
    var date: Date
    var time: Date
    var expenditure: Double
    
    static let `default` = Exercise(
        date: Date(),    // Use Date() for the default date value
        time: Date(),    // Keep the current time as default
        expenditure: 0.0      // Default to 0 for intake
    )
}
