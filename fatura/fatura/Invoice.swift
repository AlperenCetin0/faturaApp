import Foundation
import SwiftUI

public struct Invoice: Identifiable, Codable {
    public let id: UUID
    public var number: String
    public var date: Date
    public var dueDate: Date
    public var company: String
    public var amount: Double
    public var isPaid: Bool
    public var notes: String?
    
    public init(id: UUID = UUID(), number: String, date: Date, dueDate: Date, company: String, amount: Double, isPaid: Bool = false, notes: String? = nil) {
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

@MainActor
public class InvoiceManager: ObservableObject {
    @Published public var invoices: [Invoice] = []
    
    public init() {}
    
    public func addInvoice(_ invoice: Invoice) {
        invoices.append(invoice)
    }
    
    public func deleteInvoice(_ invoice: Invoice) {
        invoices.removeAll { $0.id == invoice.id }
    }
    
    public func updateInvoice(_ invoice: Invoice) {
        if let index = invoices.firstIndex(where: { $0.id == invoice.id }) {
            invoices[index] = invoice
        }
    }
}
