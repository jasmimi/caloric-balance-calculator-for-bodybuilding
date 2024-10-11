//
//  ModelData.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 22/08/2024.
//
import Foundation
import Combine
import SwiftUI

class ModelData: ObservableObject {
    // Use @Published to allow SwiftUI to observe changes to this property
    @Published var profile = Profile.default
    @Published var meal = Meal.default
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
