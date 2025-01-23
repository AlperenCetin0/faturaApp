import SwiftUI

struct InvoiceDetailView: View {
    let invoice: Invoice
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var invoiceManager: InvoiceManager
    @State private var isEditing = false
    @State private var editedInvoice: Invoice
    
    init(invoice: Invoice) {
        self.invoice = invoice
        _editedInvoice = State(initialValue: invoice)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(invoice.company)
                            .font(.title2)
                            .bold()
                        Text("Fatura No: \(invoice.number)")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    StatusBadge(isPaid: invoice.isPaid)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Amount
                HStack {
                    Text("Tutar:")
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f ₺", invoice.amount))
                        .font(.title3)
                        .bold()
                }
                
                // Dates
                Group {
                    DateRow(title: "Fatura Tarihi:", date: invoice.date)
                    DateRow(title: "Son Ödeme:", date: invoice.dueDate)
                }
                
                if let notes = invoice.notes, !notes.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Notlar")
                            .font(.headline)
                        Text(notes)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                PDFInvoiceView(invoice: invoice)
                    .padding(.top)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Kaydet" : "Düzenle") {
                    if isEditing {
                        invoiceManager.updateInvoice(editedInvoice)
                        isEditing.toggle()
                    } else {
                        isEditing.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                EditInvoiceForm(invoice: $editedInvoice)
                    .navigationTitle("Faturayı Düzenle")
                    .navigationBarItems(
                        leading: Button("İptal") {
                            isEditing = false
                        },
                        trailing: Button("Kaydet") {
                            invoiceManager.updateInvoice(editedInvoice)
                            isEditing = false
                        }
                    )
            }
        }
    }
}

struct StatusBadge: View {
    let isPaid: Bool
    
    var body: some View {
        Text(isPaid ? "Ödendi" : "Ödenmedi")
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isPaid ? Color.green : Color.red)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}

struct DateRow: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Text(date.formatted(date: .long, time: .omitted))
        }
    }
}

// End of file. No additional code.
