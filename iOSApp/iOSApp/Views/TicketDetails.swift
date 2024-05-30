//
//  TicketDetails.swift
//  iOSApp
//
//  Created by Samuel Langarica on 02/05/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import Firebase
import FirebaseDatabase

struct TicketDetails: View {
    
    @State var ticket: Ticket
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let rootRef: DatabaseReference
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Boleto Autobus")
                .font(.largeTitle)
        
            Image(uiImage: generateQrImage(from: ticket.code))
                .resizable()
                .interpolation(Image.Interpolation.none)
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            HStack {
                HStack{
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Origen")
                            .fontWeight(.bold)
                        Text(ticket.origin)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Image(systemName: "arrow.right")
                                    .foregroundColor(.blue)
                                    .padding()
                
                HStack{
                    Image(systemName: "location.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Destino")
                            .fontWeight(.bold)
                        Text(ticket.destination)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
        .padding()
    }
    
    func generateQrImage(from code: String) -> UIImage{
        filter.message = Data(code.utf8)
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let imagenResultante = filter.outputImage?.transformed(by: transform)
        {
            if let cgimg = context.createCGImage(imagenResultante, from: imagenResultante.extent)
            {
                rootRef.child("tickets").child(ticket.code).updateChildValues(["generado": true])
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    } // generateQrImage
    
}

#Preview {
    TicketDetails(ticket: Ticket(code: "qwerf-awdwe-wdcf", origin: "Tepic", destination: "Zapopan", used: true), rootRef: DatabaseReference())
}
