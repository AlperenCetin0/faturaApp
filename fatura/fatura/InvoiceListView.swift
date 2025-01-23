import SwiftUI

struct InvoiceListView: View {
    @EnvironmentObject private var invoiceManager: InvoiceManager
    @State private var showingAddInvoice = false
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .date
    
    enum SortOrder {
        case date, amount, company
    }
    
    var filteredInvoices: [Invoice] {
        let filtered = searchText.isEmpty ? invoiceManager.invoices : invoiceManager.invoices.filter { invoice in
            invoice.company.localizedCaseInsensitiveContains(searchText) ||
            invoice.number.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            switch sortOrder {
            case .date:
                return first.date > second.date
            case .amount:
                return first.amount > second.amount
            case .company:
                return first.company < second.company
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredInvoices) { invoice in
                    InvoiceRow(invoice: invoice)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                invoiceManager.deleteInvoice(invoice)
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                            
                            Button {
                                // Create a new invoice with updated isPaid status
                                var updatedInvoice = invoice
                                updatedInvoice.isPaid.toggle()
                                invoiceManager.updateInvoice(updatedInvoice)
                            } label: {
                                Label(invoice.isPaid ? "Ödenmedi" : "Ödendi", 
                                      systemImage: invoice.isPaid ? "x.circle" : "checkmark.circle")
                            }
                            .tint(invoice.isPaid ? .red : .green)
                        }
                }
            }
            .searchable(text: $searchText, prompt: "Firma veya fatura no ara")
            .navigationTitle("Faturalar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddInvoice = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddInvoice) {
                AddInvoiceView()
            }
        }
    }
}

struct InvoiceRow: View {
    let invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(invoice.company)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f ₺", invoice.amount))
                    .font(.headline)
                    .foregroundColor(invoice.isPaid ? .green : .red)
            }
            
            HStack {
                Text("Fatura No: \(invoice.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(invoice.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
