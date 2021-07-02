//
//  StatesViewModel.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation

class StatesViewModel: ObservableObject {
    
    
    @Published var allStates = [StateCustomViewModel]()
    
    
    var stateListService: StateListService
    
    init() {
        self.stateListService = StateListService()
        self.fetchStateListData()
    }
    
    
    func fetchStateListData() {
        self.stateListService.fetchStateData() { states in
            if let stateslist = states {
                DispatchQueue.main.async {
                    self.allStates = stateslist.map(StateCustomViewModel.init)
                }
            }
        }
    }
}

class StateCustomViewModel: Identifiable {
    var id = UUID()
    
    var states: StateDetails
    
    init(states: StateDetails) {
        self.states = states
    }
    
    var stateName: String {
        if let name = self.states.state_name {
            return name
        }
        return "--"
    }
    
    var stateID: Int {
        if let stateID = self.states.state_id {
            return stateID
        }
        return 0
    }
}
