//
//  Quotes.swift
//  DailyMotiv
//
//  Created by urja 💙 on 2025-04-09.
//

import Foundation

struct Quotes : Decodable,Equatable,Encodable,Identifiable {
    let id: UUID = UUID()
    
    let q: String         // ✅ will be decoded from JSON
    let a: String 
}
