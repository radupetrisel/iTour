//
//  EditDestinationView.swift
//  iTour
//
//  Created by Radu Petrisel on 17.10.2023.
//

import SwiftData
import SwiftUI

struct EditDestinationView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var destination: Destination
    @State private var newSightName = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $destination.name)
            TextField("Details", text: $destination.details, axis: .vertical)
            DatePicker("Date", selection: $destination.date)
            
            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Sights") {
                ForEach(destination.sights) {
                    Text($0.name)
                }
                .onDelete(perform: deleteSights(at:))
                
                HStack {
                    TextField("Sight name", text: $newSightName)
                    
                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit destination")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addSight() {
        guard !newSightName.isEmpty else { return }
        
        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
    
    private func deleteSights(at indices: IndexSet) {
        for index in indices {
            let sight = destination.sights.remove(at: index)
            modelContext.delete(sight)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: Destination.self, configurations: config)
        let destination = Destination(name: "Example", details: "This is a very long example detail that will be displayed on multiple lines.")
        return EditDestinationView(destination: destination)
            .modelContainer(modelContainer)
    } catch {
        fatalError("Cannot create model container.")
    }
}
