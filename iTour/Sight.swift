//
//  Sight.swift
//  iTour
//
//  Created by Radu Petrisel on 17.10.2023.
//

import Foundation
import SwiftData

@Model
final class Sight {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
