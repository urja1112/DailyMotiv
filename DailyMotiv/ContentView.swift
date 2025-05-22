//
//  ContentView.swift
//  DailyMotiv
//
//  Created by urja 💙 on 2025-04-08.
//

import SwiftUI

struct ContentView: View {
    @State private var quotes: [Quotes] = []
    @State private var isFavorited = false
    @State private var showToast = false
    @State private var refreshClicked = false
    
    var body: some View {
        
       

        NavigationStack {
            ZStack {
                LinearGradient( gradient: Gradient(colors: [.softPurple,.skyBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    Text("Today's Quotes")
                        .font(.title)
                        .foregroundStyle(.white)
                    if let quote = quotes.first {
                        VStack(alignment : .leading,spacing: 10) {
                            
                            
                            Text(quote.q)
                                .font(.title)
                                .fontWeight(.medium)
                                .padding()
                                .foregroundStyle(.white)
                                .fontDesign(.serif)
                            
                            Text("-\(quote.a)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                                .padding()
                                .fontWeight(.medium)
                                .fontDesign(.serif)
                        }
                        .frame(width: 350,height: 350)
                        .background(.white.opacity(0.20))
                        .cornerRadius(16)
                        .onAppear {
                            if let data = UserDefaults.standard.data(forKey: "favorites"),
                               let saved = try? JSONDecoder().decode([Quotes].self, from: data) {
                                isFavorited = saved.contains { $0.q == quote.q && $0.a == quote.a }
                            }
                        }
                        
                    }
                  
                    
                    
                    
                    HStack(spacing: 70){
                        Button(action: {
                            
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3,dampingFraction: 0.6)) {
                                isFavorited.toggle()
                                addToFavorite()
                            }
                        }) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundStyle(isFavorited ? .red : .white)
                                .scaleEffect(isFavorited ? 1.2 : 1.0)
                        }
                        .disabled(isFavorited)
                        Button(action :{
                            
                            
                            
                            withAnimation(.easeInOut(duration: 0.4)) {
                                refreshClicked.toggle()
                            }
                           
                            isFavorited = false
                            Task {
                                await refresh()
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                                    withAnimation{
                                        refreshClicked.toggle()
                                    }
                                }
                                
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .rotationEffect(.degrees(refreshClicked ? 180 : 0)) // 🔄 Rotation
                                       .scaleEffect(refreshClicked ? 1.3 : 1.0) // Optional bounce
                        }
                        
                        if let quote = quotes.first {
                            ShareLink(item: "\(quote.q) \n - \(quote.a)") {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(50)
                    
                    if showToast {
                        Text("❤️ Saved to Favorites")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                    }
                    
                }
                .padding()
             
                
            }
            .animation(.easeInOut, value: showToast)

                        .toolbar{
                          
                          NavigationLink(destination: favoriteView()) {
                              Image(systemName: "heart.fill")
                                  .foregroundStyle(.white)
                              
                          }
            }
            .task {
                await refresh()
            }
            
            
            
            
        }
       


    }
    func addToFavorite(){
        print("In fav")
        guard let quotes = quotes.first else {return}
           var currentFavorites : [Quotes] = []
           
         
           if let data = UserDefaults.standard.data(forKey: "favorites") {
               if let decoded = try? JSONDecoder().decode([Quotes].self, from: data) {
                   currentFavorites = decoded
               }
           }
           
           if !currentFavorites.contains(quotes) {
               currentFavorites.append(quotes)
               if let encoded = try? JSONEncoder().encode(currentFavorites) {
                   UserDefaults.standard.set(encoded, forKey: "favorites")
                   isFavorited = true
                   showToast.toggle()
                   DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                       showToast.toggle()
                   }
                   print("saved to favorite")
               }
           } else {
               print("⚠️ Already in favorites")
           }
   
            
    }
    
    func refresh() async {
        do {
            quotes = try await loadData()
        } catch {
            print(error.localizedDescription)

        }
    }
    
  
    
    func loadData() async throws -> [Quotes]{
    
        let url = URL(string: "https://zenquotes.io/api/random")!
           let (data, _) = try await URLSession.shared.data(from: url)

           // 🔍 Print the raw JSON response
           if let json = String(data: data, encoding: .utf8) {
               print("🧾 JSON Response:\n\(json)")
           }

        let decoded = try JSONDecoder().decode([Quotes].self, from: data)
        
        print(decoded)
        return decoded
        
    }
}

#Preview {
    ContentView()
}
