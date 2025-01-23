import SwiftUI

struct CustomerDetailView: View {
    let customer: Customer
    @EnvironmentObject private var customerManager: CustomerManager
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var editedCustomer: Customer
    
    init(customer: Customer) {
        self.customer = customer
        _editedCustomer = State(initialValue: customer)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Customer Info
                CustomerInfoSection(customer: customer)
                
                // Contact Info
                ContactInfoSection(customer: customer)
                
                // Notes
                if let notes = customer.notes {
                    VStack(alignment: .leading) {
                        Text("Notlar")
                            .font(.headline)
                        Text(notes)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(customer.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Kaydet" : "Düzenle") {
                    if isEditing {
                        customerManager.updateCustomer(editedCustomer)
                        isEditing.toggle()
                    } else {
                        isEditing.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                CustomerEditForm(customer: $editedCustomer)
                    .navigationTitle("Müşteriyi Düzenle")
                    .navigationBarItems(
                        leading: Button("İptal") {
                            isEditing = false
                        },
                        trailing: Button("Kaydet") {
                            customerManager.updateCustomer(editedCustomer)
                            isEditing = false
                        }
                    )
            }
        }
    }
}

struct CustomerInfoSection: View {
    let customer: Customer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Firma Bilgileri")
                .font(.headline)
            
            InfoRow(title: "Firma Adı", value: customer.name)
            if let taxNumber = customer.taxNumber {
                InfoRow(title: "Vergi No", value: taxNumber)
            }
            if let address = customer.address {
                InfoRow(title: "Adres", value: address)
            }
        }
    }
}

struct ContactInfoSection: View {
    let customer: Customer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("İletişim Bilgileri")
                .font(.headline)
            
            if let phone = customer.phone {
                InfoRow(title: "Telefon", value: phone)
            }
            if let email = customer.email {
                InfoRow(title: "E-posta", value: email)
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}

// End of file. No additional code.
