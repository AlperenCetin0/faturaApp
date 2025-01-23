//
//  ContentView.swift
//  fatura
//
//  Created by Alperen Çetin on 6.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var invoiceManager = InvoiceManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .environmentObject(invoiceManager)
                .tabItem {
                    Label("Özet", systemImage: "chart.pie.fill")
                }
                .tag(0)
            
            InvoiceListView()
                .environmentObject(invoiceManager)
                .tabItem {
                    Label("Faturalar", systemImage: "doc.text.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

struct Invoice: Identifiable, Codable {
    let id: UUID
    var number: String
    var date: Date
    var dueDate: Date
    var company: String
    var amount: Double
    var isPaid: Bool
    var notes: String?
    
    init(id: UUID = UUID(), number: String, date: Date, dueDate: Date, company: String, amount: Double, isPaid: Bool = false, notes: String? = nil) {
        self.id = id
        self.number = number
        self.date = date
        self.dueDate = dueDate
        self.company = company
        self.amount = amount
        self.isPaid = isPaid
        self.notes = notes
    }
}

class InvoiceManager: ObservableObject {
    @Published var invoices: [Invoice] = []
    
    func addInvoice(_ invoice: Invoice) {
        invoices.append(invoice)
    }
    
    func deleteInvoice(_ invoice: Invoice) {
        invoices.removeAll { $0.id == invoice.id }
    }
    
    func updateInvoice(_ invoice: Invoice) {
        if let index = invoices.firstIndex(where: { $0.id == invoice.id }) {
            invoices[index] = invoice
        }
    }
}

#Preview {
}
