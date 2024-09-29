//
//  cbc4bApp.swift
//  cbc4b
//
//  Created by Jasmine Amohia on 20/08/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreInternal
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct cbc4bApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var modelData = ModelData()
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(authManager)
        }
    }
}
