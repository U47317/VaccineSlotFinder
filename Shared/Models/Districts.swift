//
//  Districts.swift
//  CowinApp
//
//  Created by Arun Mohan on 16/06/21.
//

import Foundation

struct Districts: Codable {
    var districts: [DistrictDetail]?
    var ttl: Int?
}

struct DistrictDetail: Codable {
    var district_id: Int?
    var district_name: String?
}
