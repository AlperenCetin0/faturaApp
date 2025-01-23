import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct PDFInvoiceView: View {
    let invoice: Invoice
    @AppStorage("companyName") private var companyName = ""
    @AppStorage("taxNumber") private var taxNumber = ""
    @AppStorage("address") private var address = ""
    @State private var showShareSheet = false
    @State private var pdfData: Data?
    
    var body: some View {
        Button(action: {
            createAndSharePDF()
        }) {
            Label("PDF Oluştur", systemImage: "doc.fill")
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let data = pdfData {
                ShareSheet(activityItems: [data])
            }
        })
    }
    
    private func createAndSharePDF() {
        let pageWidth: CGFloat = 595.2  // A4 width in points
        let pageHeight: CGFloat = 841.8  // A4 height in points
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let pdfMetaData = [
            kCGPDFContextCreator: companyName,
            kCGPDFContextAuthor: companyName,
            kCGPDFContextTitle: "Fatura #\(invoice.number)"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
            let cgContext = context.cgContext
            
            // Header Background
            let headerRect = CGRect(x: 40, y: 40, width: pageWidth - 80, height: 100)
            cgContext.setFillColor(UIColor.systemBlue.withAlphaComponent(0.1).cgColor)
            cgContext.fill(headerRect)
            
            // Company Info
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkGray
            ]
            
            // Draw Company Info
            companyName.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            
            let companyDetails = """
            Vergi No: \(taxNumber)
            Adres: \(address)
            """
            companyDetails.draw(at: CGPoint(x: 50, y: 80), withAttributes: companyAttributes)
            
            // Invoice Details
            let invoiceTitle = "FATURA #\(invoice.number)"
            let invoiceTitleRect = CGRect(x: pageWidth - 250, y: 50, width: 200, height: 30)
            invoiceTitle.draw(in: invoiceTitleRect, withAttributes: titleAttributes)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            
            let invoiceDetails = """
            Tarih: \(dateFormatter.string(from: invoice.date))
            Vade: \(dateFormatter.string(from: invoice.dueDate))
            """
            invoiceDetails.draw(at: CGPoint(x: pageWidth - 250, y: 90), withAttributes: companyAttributes)
            
            // Content
            let contentRect = CGRect(x: 40, y: 160, width: pageWidth - 80, height: pageHeight - 200)
            let contentAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12)
            ]
            
            // Draw Customer Info
            let customerInfo = """
            MÜŞTERİ BİLGİLERİ
            \(invoice.company)
            """
            customerInfo.draw(in: contentRect, withAttributes: contentAttributes)
            
            // Draw Amount
            let amountText = String(format: "Toplam Tutar: %.2f ₺", invoice.amount)
            let amountAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16)
            ]
            
            amountText.draw(at: CGPoint(x: pageWidth - 250, y: pageHeight - 100), withAttributes: amountAttributes)
        }
        
        // Save PDF
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = paths[0]
        let filePath = docDirectory.appendingPathComponent("Fatura_\(invoice.number).pdf")
        try? data.write(to: filePath)
        
        pdfData = data
        showShareSheet = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
