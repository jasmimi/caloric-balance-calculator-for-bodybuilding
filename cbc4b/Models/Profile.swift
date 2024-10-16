//
//  Profile.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//

import Foundation

struct Profile {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var prefersNotifications =  true
    var age: Double
    var height: Height
    var weight: Double
    var sex: Sex
    var fitnessActivityLevel: FitnessActivityLevel
    var goal: Goal
    
    // TO CALCULATE WITH EQUATIONs
    var goalCalories: Double
    
    static let `default` = Profile(
        email: "jvq3854@autuni.ac.nz"
        , password: "meow"
        , firstName: "Jasmine"
        , lastName: "Amohia"
        , prefersNotifications: true
        , age: 21
        , height: Height.fi
        , weight: 60.1
        , sex: Sex.f
        , fitnessActivityLevel: FitnessActivityLevel.va
        , goal: Goal.m
        , goalCalories: 1000)
    
    static let blank = Profile(
        email: ""
        , password: ""
        , firstName: ""
        , lastName: ""
        , prefersNotifications: true
        , age: 0
        , height: .unspecified
        , weight: 0
        , sex: .unspecified
        , fitnessActivityLevel: .unspecified
        , goal: .unspecified
        , goalCalories: 0)
    
    enum Height: String, CaseIterable, Identifiable {
        case unspecified = ""
        case foon = "4'1\""
        case fotw = "4'2\""
        case foth = "4'3\""
        case fofo = "4'4\""
        case fofi = "4'5\""
        case fosi = "4'6\""
        case fose = "4'7\""
        case foei = "4'8\""
        case foni = "4'9\""
        case fote = "4'10\""
        case foel = "4'11\""
        
        case fi = "5'0"
        case fion = "5'1\""
        case fitw = "5'2\""
        case fith = "5'3\""
        case fifo = "5'4\""
        case fifi = "5'5\""
        case fisi = "5'6\""
        case fise = "5'7\""
        case fiei = "5'8\""
        case fini = "5'9\""
        case fite = "5'10\""
        case fiel = "5'11\""
        
        case si = "6'0"
        case sion = "6'1\""
        case sitw = "6'2\""
        case sith = "6'3\""
        case sifo = "6'4\""
        case sifi = "6'5\""
        case sisi = "6'6\""
        case sise = "6'7\""
        case siei = "6'8\""
        case sini = "6'9\""
        case site = "6'10\""
        case siel = "6'11\""
        
        var id: String { rawValue }

    }
    
    enum Sex: String, CaseIterable, Identifiable {
        case unspecified = ""
        case f = "Female"
        case m = "Male"
        var id: String { rawValue }
    }
    
    enum FitnessActivityLevel: String, CaseIterable, Identifiable {
        case unspecified = ""
        case s = "Sedentary: little or no exercise"
        case l = "Light: exercise 1-3 times/week"
        case m = "Moderate: exercise 4-5 times/week"
        case a = "Active: daily exercise or intense exercise 3-4 times/week"
        case va = "Very Active: intense exercise 6-7 times/week"
        case ea = "Extra Active: very intense exercise daily, or physical job"
        
        var id: String { rawValue }
    }
    
    enum Goal: String, CaseIterable, Identifiable {
        case unspecified = ""
        case mc = "Major cut"
        case c = "Cut"
        case m = "Maintain"
        case b = "Bulk"
        case mb = "Major bulk"
        
        var id: String { rawValue }
    }
}
