//
//  faturaApp.swift
//  fatura
//
//  Created by Alperen Çetin on 6.01.2025.
//

import SwiftUI

@main
struct faturaApp: App {
    // Add StateObject for app-wide state management
    @StateObject private var invoiceManager = InvoiceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(invoiceManager)
                .preferredColorScheme(.light) // Force light mode for professional look
                .accentColor(.blue)  // Use consistent accent color
                .onAppear {
                    // Set up UI appearance
                    setupAppearance()
                }
        }
    }
    
    private func setupAppearance() {
        // Configure navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
