import SwiftUI

struct CustomerListView: View {
    @StateObject private var customerManager = CustomerManager()
    @State private var showingAddCustomer = false
    @State private var searchText = ""
    
    var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return customerManager.customers
        } else {
            return customerManager.customers.filter { customer in
                customer.name.localizedCaseInsensitiveContains(searchText) ||
                customer.taxNumber?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCustomers) { customer in
                    NavigationLink(destination: CustomerDetailView(customer: customer)) {
                        CustomerRow(customer: customer)
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            customerManager.deleteCustomer(customer)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Müşteri ara")
            .navigationTitle("Müşteriler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCustomer = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddCustomer) {
                AddCustomerView()
                    .environmentObject(customerManager)
            }
        }
    }
}

struct CustomerRow: View {
    let customer: Customer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(customer.name)
                .font(.headline)
            if let taxNumber = customer.taxNumber {
                Text("VKN: \(taxNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// End of file. No additional code.
