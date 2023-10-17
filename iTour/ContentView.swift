//
//  ContentView.swift
//  iTour
//
//  Created by Radu Petrisel on 16.10.2023.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var destinations: [Destination]
    @State private var path = [Destination]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(destinations) { destination in
                    NavigationLink(value: destination) {
                        VStack(alignment: .leading) {
                            Text(destination.name)
                                .font(.headline)
                            
                            Text(destination.date.formatted(date: .long, time: .shortened))
                        }
                    }
                }
                .onDelete(perform: deleteDestination(_:))
            }
            .navigationTitle("iTour")
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init(destination:))
            .toolbar {
                Button("Add", systemImage: "plus", action: addDestination)
            }
        }
    }
    
    private func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        
        path = [destination]
    }
    
    private func deleteDestination(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    ContentView()
}
