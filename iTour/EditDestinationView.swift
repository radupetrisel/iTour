//
//  EditDestinationView.swift
//  iTour
//
//  Created by Radu Petrisel on 17.10.2023.
//

import SwiftData
import SwiftUI

struct EditDestinationView: View {
    @Bindable var destination: Destination
    
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
        }
        .navigationTitle("Edit destination")
        .navigationBarTitleDisplayMode(.inline)
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