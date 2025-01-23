import SwiftUI

struct AddInvoiceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var invoiceManager: InvoiceManager
    
    @State private var number = ""
    @State private var company = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var dueDate = Date()
    @State private var notes = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fatura Bilgileri")) {
                    TextField("Fatura No", text: $number)
                        .keyboardType(.default)
                    TextField("Firma Adı", text: $company)
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Tarihler")) {
                    DatePicker("Fatura Tarihi", selection: $date, displayedComponents: .date)
                    DatePicker("Son Ödeme Tarihi", selection: $dueDate, displayedComponents: .date)
                }
                
                Section(header: Text("Notlar")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Yeni Fatura")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveInvoice()
                    }
                }
            }
            .alert("Hata", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Lütfen tüm alanları doldurun")
            }
        }
    }
    
    private func saveInvoice() {
        guard !number.isEmpty,
              !company.isEmpty,
              let amountValue = Double(amount),
              !amount.isEmpty else {
            showingAlert = true
            return
        }
        
        let invoice = Invoice(
            number: number,
            date: date,
            dueDate: dueDate,
            company: company,
            amount: amountValue,
            notes: notes.isEmpty ? nil : notes
        )
        
        invoiceManager.addInvoice(invoice)
        dismiss()
    }
}

// End of file. No additional code.
