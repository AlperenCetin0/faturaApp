import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject private var invoiceManager: InvoiceManager
    
    private var totalAmount: Double {
        invoiceManager.invoices.reduce(0) { $0 + $1.amount }
    }
    
    private var paidAmount: Double {
        invoiceManager.invoices.filter { $0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    
    private var unpaidAmount: Double {
        totalAmount - paidAmount
    }
    
    private var recentInvoices: [Invoice] {
        Array(invoiceManager.invoices.prefix(5))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    summaryCardsSection
                    
                    // Charts Section
                    chartsSection
                    
                    // Recent Invoices
                    recentInvoicesSection
                }
                .padding()
            }
            .navigationTitle("Özet")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - View Components
    private var summaryCardsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            SummaryCard(title: "Toplam",
                      amount: totalAmount,
                      icon: "doc.text.fill",
                      color: .blue)
            
            SummaryCard(title: "Ödendi",
                      amount: paidAmount,
                      icon: "checkmark.circle.fill",
                      color: .green)
            
            SummaryCard(title: "Ödenmedi",
                      amount: unpaidAmount,
                      icon: "exclamationmark.circle.fill",
                      color: .red)
            
            SummaryCard(title: "Fatura Sayısı",
                      amount: Double(invoiceManager.invoices.count),
                      icon: "number.circle.fill",
                      color: .orange,
                      isCount: true)
        }
    }
    
    private var chartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fatura Analizi")
                .font(.headline)
                .padding(.horizontal)
            
            if #available(iOS 16.0, *) {
                Chart {
                    BarMark(
                        x: .value("Durum", "Toplam"),
                        y: .value("Tutar", totalAmount)
                    )
                    .foregroundStyle(.blue)
                    
                    BarMark(
                        x: .value("Durum", "Ödendi"),
                        y: .value("Tutar", paidAmount)
                    )
                    .foregroundStyle(.green)
                    
                    BarMark(
                        x: .value("Durum", "Ödenmedi"),
                        y: .value("Tutar", unpaidAmount)
                    )
                    .foregroundStyle(.red)
                }
                .frame(height: 200)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
    }
    
    private var recentInvoicesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Son Faturalar")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(recentInvoices) { invoice in
                NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                    RecentInvoiceRow(invoice: invoice)
                }
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    var isCount: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(isCount ? String(format: "%.0f", amount) : String(format: "%.2f ₺", amount))
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RecentInvoiceRow: View {
    let invoice: Invoice
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(invoice.company)
                    .font(.headline)
                Text(invoice.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f ₺", invoice.amount))
                    .font(.headline)
                    .foregroundColor(invoice.isPaid ? .green : .red)
                
                Text(invoice.isPaid ? "Ödendi" : "Bekliyor")
                    .font(.caption)
                    .padding(4)
                    .background(invoice.isPaid ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(invoice.isPaid ? .green : .red)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
