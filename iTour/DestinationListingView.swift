//
//  DestinationListingView.swift
//  iTour
//
//  Created by Radu Petrisel on 17.10.2023.
//

import SwiftData
import SwiftUI

struct DestinationListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var destinations: [Destination]
    
    var body: some View {
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
    }
    
    init(sort: SortDescriptor<Destination>, filterString: String) {
        _destinations = Query(filter: #Predicate {
            if filterString.isEmpty {
                true
            }
            else {
                $0.name.localizedStandardContains(filterString)
            }
        }, sort: [sort])
    }
    
    private func deleteDestination(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    DestinationListingView(sort: SortDescriptor(\.name), filterString: "")
}
