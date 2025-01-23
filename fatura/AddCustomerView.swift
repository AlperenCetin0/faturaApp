import SwiftUI

struct AddCustomerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var customerManager: CustomerManager
    
    @State private var name = ""
    @State private var taxNumber = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var notes = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Firma Bilgileri")) {
                    TextField("Firma Adı", text: $name)
                    TextField("Vergi Numarası", text: $taxNumber)
                        .keyboardType(.numberPad)
                    TextField("Adres", text: $address)
                }
                
                Section(header: Text("İletişim Bilgileri")) {
                    TextField("Telefon", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Notlar")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Yeni Müşteri")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveCustomer()
                    }
                }
            }
            .alert("Hata", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Lütfen firma adını girin")
            }
        }
    }
    
    private func saveCustomer() {
        guard !name.isEmpty else {
            showingAlert = true
            return
        }
        
        let customer = Customer(
            name: name,
            taxNumber: taxNumber.isEmpty ? nil : taxNumber,
            address: address.isEmpty ? nil : address,
            phone: phone.isEmpty ? nil : phone,
            email: email.isEmpty ? nil : email,
            notes: notes.isEmpty ? nil : notes
        )
        
        customerManager.addCustomer(customer)
        dismiss()
    }
}

// End of file. No additional code.
