//
//  States.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation


struct States: Codable {
    var states: [StateDetails]?
    var ttl: Int?
}

struct StateDetails: Codable {
    var state_id: Int?
    var state_name: String?
}
