//
//  StateListService.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation

class StateListService {
    
    private static  let linkk = "https://cdn-api.co-vin.in/api/v2/admin/location/states"
    
    func fetchStateData(completion: @escaping ([StateDetails]?) -> ()) {
        
        guard let url = URL(string: StateListService.linkk) else {
            completion(nil)
            return
        }
        let urlSession = URLSession(configuration: .ephemeral)
        
        urlSession.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            guard let stateResponse = try? JSONDecoder().decode(States.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(stateResponse.states)
            
        }.resume()
    }
}
