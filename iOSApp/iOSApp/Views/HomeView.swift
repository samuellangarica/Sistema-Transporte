import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    @State var tickets: [Ticket] = []
    let rootRef: DatabaseReference
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init() {
        rootRef = Database.database().reference()
        fetchTicketsForCurrentUser()
    }
    
    func fetchTicketsForCurrentUser() {
        // Existing function implementation
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Text("Mis Boletos")
                    .font(.title)
                
                Image(systemName: "bus")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                NavigationStack {
                    List(tickets) { ticket in
                        NavigationLink("\(ticket.origin) → \(ticket.destination)", value: ticket)
                    }
                    .navigationDestination(for: Ticket.self) { ticket in
                        TicketDetails(ticket: ticket, rootRef: rootRef)
                    }
                }
                
                Button(action: {
                    getFirstTicketWithNoUserID()
                        }) {
                            Text("Compar boleto")
                                .foregroundColor(.white)
                                .padding()
                                .background(.blue)
                                .cornerRadius(25)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertMessage))
                        }
                        .padding()
                
                HStack { // Bottom bar
                    Spacer()
                    Image(systemName: "ticket.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                    NavigationLink(destination: ProfileView(rootRef: rootRef)) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    }.padding()
                    Spacer()
                }
                .background(Color.primary)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchTicketData()
        }
    }
    
    func fetchTicketData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        rootRef.child("tickets")
            .queryOrdered(byChild: "user_id")
            .queryEqual(toValue: userID)
            .observeSingleEvent(of: .value, with: { snapshot in

                var fetchedTickets: [Ticket] = []

                // Ensure snapshot is a DataSnapshot
                guard let dataSnapshot = snapshot as? DataSnapshot else {
                    print("Error retrieving data")
                    return
                }

                // Access children directly
                guard let children = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
                for child in children {
                    if let childData = child.value as? [String: Any] {
                        fetchedTickets.append(Ticket(
                            code: child.key,
                            origin: childData["origin"] as? String ?? "Unknown origin",
                            destination: childData["destination"] as? String ?? "Unknown destination",
                            used: childData["utilizado"] as? Bool ?? false
                        ))
                    }
                }

                self.tickets = fetchedTickets
            })
    }
    
    func generateTicket() {
        let cities = ["Tepic", "Guadalajara", "Zapopan", "Monterrey", "Mérida", "Arandas", "CDMX"]
        
        // Select a random origin city
        let originIndex = Int.random(in: 0..<cities.count)
        let originCity = cities[originIndex]
        
        // Select a random destination city different from the origin city
        var destinationIndex = Int.random(in: 0..<cities.count)
        while destinationIndex == originIndex {
            destinationIndex = Int.random(in: 0..<cities.count)
        }
        let destinationCity = cities[destinationIndex]
        
        let ticketUUID = UUID()
        let ticket = [
            "user_id": nil,
            "utilizado": false,
            "coord": nil,
            "origin": originCity, // Add the origin city to the ticket
            "destination": destinationCity // Add the destination city to the ticket
        ] as [String : Any?]
        let ticketRef = rootRef.child("tickets").child(ticketUUID.uuidString)
        ticketRef.setValue(ticket)
    }
    
    func getFirstTicketWithNoUserID() {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        // Function to process tickets
        func processTickets(_ snapshot: DataSnapshot) -> Bool {
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                var ticketData = child.value as! [String: Any]
                ticketData["user_id"] = userID
                self.tickets.append(Ticket(
                    code: child.key,
                    origin: ticketData["origin"] as? String ?? "Unknown origin",
                    destination: ticketData["destination"] as? String ?? "Unknown destination",
                    used: ticketData["utilizado"] as? Bool ?? false
                ))
                
                // Write the updated data back to the database
                let ticketRef = self.rootRef.child("tickets").child(child.key)
                ticketRef.setValue(ticketData)
                
                alertMessage = "Compra de boleto exitosa"
                showAlert = true
                return true // Indicates that a ticket was processed
            }
            return false // No tickets processed
        }
        
        // First query: tickets where user_id is nil
        rootRef.child("tickets")
            .queryOrdered(byChild: "user_id")
            .queryEqual(toValue: nil)
            .observeSingleEvent(of: .value) { snapshot in
            
                if processTickets(snapshot) {
                    return // Exit if a ticket was processed
                }
                
                // Second query: tickets where user_id is an empty string
                self.rootRef.child("tickets")
                    .queryOrdered(byChild: "user_id")
                    .queryEqual(toValue: "")
                    .observeSingleEvent(of: .value) { snapshot in
                        if !processTickets(snapshot) {
                            alertMessage = "No hay boletos disponibles, intente de nuevo más tarde"
                            showAlert = true
                        }
                    }
            }
    }
}

#Preview {
    HomeView()
}
