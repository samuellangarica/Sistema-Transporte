//
//  Ticket.swift
//  iOSApp
//
//  Created by Samuel Langarica on 02/05/24.
//

import Foundation

struct Ticket: Identifiable, Hashable {
    let id =  UUID()
    let code: String
    let origin: String
    let destination: String
    let used: Bool
    
    init(code: String, origin: String, destination: String, used: Bool) {
        self.code = code
        self.origin = origin
        self.destination = destination
        self.used = used
    }
}
