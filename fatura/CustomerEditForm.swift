import SwiftUI

struct CustomerEditForm: View {
    @Binding var customer: Customer
    
    var body: some View {
        Form {
            Section(header: Text("Firma Bilgileri")) {
                TextField("Firma Adı", text: $customer.name)
                TextField("Vergi Numarası", text: Binding(
                    get: { customer.taxNumber ?? "" },
                    set: { customer.taxNumber = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.numberPad)
                TextField("Adres", text: Binding(
                    get: { customer.address ?? "" },
                    set: { customer.address = $0.isEmpty ? nil : $0 }
                ))
            }
            
            Section(header: Text("İletişim Bilgileri")) {
                TextField("Telefon", text: Binding(
                    get: { customer.phone ?? "" },
                    set: { customer.phone = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.phonePad)
                TextField("E-posta", text: Binding(
                    get: { customer.email ?? "" },
                    set: { customer.email = $0.isEmpty ? nil : $0 }
                ))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            }
            
            Section(header: Text("Notlar")) {
                TextEditor(text: Binding(
                    get: { customer.notes ?? "" },
                    set: { customer.notes = $0.isEmpty ? nil : $0 }
                ))
                .frame(height: 100)
            }
        }
    }
}

// End of file. No additional code.
