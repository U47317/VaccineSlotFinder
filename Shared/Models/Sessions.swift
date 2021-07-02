//
//  Sessions.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation


struct Sessions: Codable {
    
    var sessions: [Slots]
}


struct Slots: Codable {
    var name: String?
    var address: String?
    var district_name: String?
    var fee_type: String?
    var min_age_limit: Int?
    var available_capacity: Int?
    var available_capacity_dose1: Int?
    var available_capacity_dose2: Int?
    var vaccine: String?
}
