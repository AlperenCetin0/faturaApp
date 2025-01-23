import SwiftUI

struct EditInvoiceForm: View {
    @Binding var invoice: Invoice
    
    var body: some View {
        Form {
            Section(header: Text("Fatura Bilgileri")) {
                TextField("Fatura No", text: $invoice.number)
                TextField("Firma Adı", text: $invoice.company)
                TextField("Tutar", value: $invoice.amount, format: .number)
                    .keyboardType(.decimalPad)
                Toggle("Ödendi", isOn: $invoice.isPaid)
            }
            
            Section(header: Text("Tarihler")) {
                DatePicker("Fatura Tarihi",
                          selection: $invoice.date,
                          displayedComponents: .date)
                DatePicker("Son Ödeme Tarihi",
                          selection: $invoice.dueDate,
                          displayedComponents: .date)
            }
            
            Section(header: Text("Notlar")) {
                if let bindingNotes = Binding($invoice.notes) {
                    TextEditor(text: bindingNotes)
                        .frame(height: 100)
                }
            }
        }
    }
}

// End of file. No additional code.
