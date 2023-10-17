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
    @State private var path = [Destination]()
    @State private var sortDescriptor = SortDescriptor(\Destination.name)
    @State private var searchString = ""
    @State private var showAll = true
    
    private var sort: [SortDescriptor<Destination>] {
        [
            sortDescriptor,
            .init(\.name)
        ]
    }
    
    private var filter: Predicate<Destination> {
        let now = Date.now
        return #Predicate<Destination> {
            if searchString.isEmpty {
                showAll || $0.date > now
            }
            else {
                (showAll || $0.date > now) && $0.name.localizedStandardContains(searchString)
            }
        }
    }
        
    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sort: sort, filter: filter)
                .navigationTitle("iTour")
                .navigationDestination(for: Destination.self, destination: EditDestinationView.init(destination:))
                .searchable(text: $searchString)
                .toolbar {
                    Button("Add", systemImage: "plus", action: addDestination)
                    
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortDescriptor) {
                            Text("Name")
                                .tag(SortDescriptor(\Destination.name))
                            
                            Text("Priority")
                                .tag(SortDescriptor(\Destination.priority, order: .reverse))
                            
                            Text("Date")
                                .tag(SortDescriptor(\Destination.date))
                        }
                        .pickerStyle(.inline)
                    }
                    
                    Menu("Filter future", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter future", selection: $showAll) {
                            Text("All")
                                .tag(true)
                            
                            Text("Future only")
                                .tag(false)
                        }
                    }
                }
        }
    }
    
    private func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        
        path = [destination]
    }
}

#Preview {
    ContentView()
}
