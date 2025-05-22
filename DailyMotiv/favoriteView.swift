//
//  favoriteView.swift
//  DailyMotiv
//
//  Created by urja 💙 on 2025-04-09.
//

import SwiftUI

struct favoriteView: View {
    
    @State private var quotes: [Quotes] = []
//    let columns = [
//        GridItem(.adaptive(minimum: 160), spacing: 10)
//     ]

    var body: some View {
        
        
        
        
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [.softPurple, .skyBlue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Transparent List
            List {
                ForEach(quotes) { quote in
                    ShareLink(item : "\(quote.q) \n - \(quote.a)") {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(quote.q)
                                .font(.title)
                                .foregroundStyle(.white)
                            Text("— \(quote.a)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .padding()
                        .frame(minWidth: 300, maxWidth: 360)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        //.padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .onDelete(perform: deleteQuote)
            }
            
            .scrollContentBackground(.hidden) // ✅ Hides the whole List background
        }
        .navigationTitle("Favorites")
        .onAppear {
            loadFav()
        }
    }
        
    func deleteQuote(at offSet : IndexSet) {
        
        quotes.remove(atOffsets: offSet)
        if let encoded = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    func loadFav() {
        print("hello")
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            if let savedQuotes = try? JSONDecoder().decode([Quotes].self, from: data) {
                quotes = savedQuotes
                print("quotes \(quotes)")
            }
                
        }
    }
}

#Preview {
    favoriteView()
}
