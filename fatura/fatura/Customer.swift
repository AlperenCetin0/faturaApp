import Foundation

// Create Customer model for storing customer information
struct Customer: Identifiable, Codable {
    let id: UUID
    var name: String
    var taxNumber: String?
    var address: String?
    var phone: String?
    var email: String?
    var notes: String?
    
    init(id: UUID = UUID(), name: String, taxNumber: String? = nil, address: String? = nil, phone: String? = nil, email: String? = nil, notes: String? = nil) {
        self.id = id
        self.name = name
        self.taxNumber = taxNumber
        self.address = address
        self.phone = phone
        self.email = email
        self.notes = notes
    }
}

// Create CustomerManager for handling customer operations
class CustomerManager: ObservableObject {
    @Published var customers: [Customer] = []
    
    func addCustomer(_ customer: Customer) {
        customers.append(customer)
    }
    
    func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.id == customer.id }
    }
    
    func updateCustomer(_ customer: Customer) {
        if let index = customers.firstIndex(where: { $0.id == customer.id }) {
            customers[index] = customer
        }
    }
}

// End of file. No additional code.
