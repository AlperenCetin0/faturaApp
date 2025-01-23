import SwiftUI

struct SettingsView: View {
    @AppStorage("companyName") private var companyName = ""
    @AppStorage("taxNumber") private var taxNumber = ""
    @AppStorage("address") private var address = ""
    @AppStorage("phone") private var phone = ""
    @AppStorage("email") private var email = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Şirket Bilgileri")) {
                    TextField("Şirket Adı", text: $companyName)
                    TextField("Vergi Numarası", text: $taxNumber)
                        .keyboardType(.numberPad)
                    TextField("Adres", text: $address)
                    TextField("Telefon", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Uygulama Hakkında")) {
                    HStack {
                        Text("Versiyon")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

// End of file. No additional code.
