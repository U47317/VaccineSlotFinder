//
//  DistrictListService.swift
//  CowinApp
//
//  Created by Arun Mohan on 16/06/21.
//

import Foundation

class DistrictListService {
    
    
    func fetchDistrictData(stateID: Int, completion: @escaping ([DistrictDetail]?) -> ()) {
        let linkk = "https://cdn-api.co-vin.in/api/v2/admin/location/districts/\(stateID))"
        
        guard let url = URL(string: linkk) else {
            completion(nil)
            return
        }
        let urlSession = URLSession(configuration: .ephemeral)
        
        urlSession.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            guard let districtResponse = try? JSONDecoder().decode(Districts.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(districtResponse.districts)
            
        }.resume()
    }
}
