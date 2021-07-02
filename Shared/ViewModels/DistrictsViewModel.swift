//
//  DistrictsViewModel.swift
//  CowinApp
//
//  Created by Arun Mohan on 16/06/21.
//

import Foundation

class DistrictsViewModel: ObservableObject {
    
    
    @Published var allDistricts = [DistrictsCustomViewModel]()
    
    var districtListService: DistrictListService
    var stateID: Int = 0
    
    init() {
        self.districtListService = DistrictListService()
    }
    
    
    func fetchDistrictListData() {
        self.districtListService.fetchDistrictData(stateID: self.stateID) { districts in
            if let districtlist = districts {
                DispatchQueue.main.async {
                    self.allDistricts = districtlist.map(DistrictsCustomViewModel.init)
                }
            }
        }
    }
}

class DistrictsCustomViewModel: Identifiable {
    var id = UUID()
    
    var districts: DistrictDetail
    
    init(districts: DistrictDetail) {
        self.districts = districts
    }
    
    var districtName: String {
        if let name = self.districts.district_name{
            return name
        }
        return "--"
    }
    
    var districtID: Int {
        if let districtID = self.districts.district_id {
            return districtID
        }
        return 0
    }
}
