//
//  CowinService.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation

class CowinService {
    
    
    func fetchVaccinationData(districtID: Int, vaccinationDate: String, completion: @escaping ([Slots]?) -> ()) {
        let linkk = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=\(districtID)&date=\(vaccinationDate)"
        
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
                
            guard let cowinResponse = try? JSONDecoder().decode(Sessions.self, from: data) else {
                completion(nil)
                return
            }
                
            completion(cowinResponse.sessions)
            
        }.resume()
        
        
    }
}
