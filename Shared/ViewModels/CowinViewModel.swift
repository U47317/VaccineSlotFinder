//
//  CowinViewModel.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import Foundation
import AVFoundation


class CowinViewModel: ObservableObject {
    
    
    @Published var allSlots = [CustomViewModel]()
    var districID: Int = 0
    var districtName: String = ""
    var date: Date = Date()
    var notificationAgeLimit: AgeLimit.RawValue = 18
    var notificationDoseLimit: DoseType.RawValue = 1
    var notificationVaccineType: VaccineType.RawValue = VaccineType.Covisheield.rawValue
    var isUserNeedsToBeNotified = false
    private static var isTimerTriggered: Bool = false
    var cowinService: CowinService
    var audioPlayer: AVAudioPlayer?
    
    init() {
        self.cowinService = CowinService()
    }
    
    func fetchDataReqularly() {
        self.fetchVaccineData()
        if !CowinViewModel.isTimerTriggered {
            CowinViewModel.isTimerTriggered = true
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true){ tempTimer in
                self.fetchVaccineData()
            }
        }
    }
    
    func fetchVaccineData() {
        self.allSlots = []
        self.isUserNeedsToBeNotified = false
        self.cowinService.fetchVaccinationData(districtID: self.districID, vaccinationDate: formatDate(date: self.date)) { slots in
            if let slots = slots {
                DispatchQueue.main.async {
                    var tempSlots = slots.map(CustomViewModel.init)
                    tempSlots = (tempSlots.filter({$0.minAgeLimit == self.notificationAgeLimit})).sorted(by: {$0.availableCapacity > $1.availableCapacity})
                    tempSlots = tempSlots.filter({$0.vaccine == self.notificationVaccineType})
                    if self.notificationDoseLimit == 1 {
                        self.allSlots = tempSlots.sorted(by: {$0.dose1Slots > $1.dose1Slots})
                    } else {
                        self.allSlots = tempSlots.sorted(by: {$0.dose2Slots > $1.dose2Slots})
                    }
                    self.playSound()
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss E"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func playSound() {
        for index in 0..<allSlots.count {
            if self.allSlots[index].availableCapacity > 0 && self.allSlots[index].minAgeLimit == self.notificationAgeLimit {
                if (self.notificationDoseLimit == 1 && self.allSlots[index].dose1Slots > 0) || (self.notificationDoseLimit == 2 && self.allSlots[index].dose2Slots > 0) {
                    self.isUserNeedsToBeNotified = true
                    let systemSoundID: SystemSoundID = 1017
                    AudioServicesPlaySystemSound(systemSoundID)
                    break
                }
            }
        }
    }
}

class CustomViewModel: Identifiable {
    var id = UUID()
    
    var slots: Slots
    
    init(slots: Slots) {
        self.slots = slots
    }
    
    var name: String {
        if let name = self.slots.name {
            return name
        }
        return "--"
    }
    
    var address: String {
        if let address = self.slots.address {
            return address
        }
        return "--"
    }
    
    var districtName: String {
        if let distName = self.slots.district_name {
            return distName
        }
        return "--"
    }
    
    var feeType: String {
        if let feeType = self.slots.fee_type {
            return feeType
        }
        return "--"
    }
    
    var vaccine: String {
        if let vaccine = self.slots.vaccine {
            return vaccine
        }
        return "--"
    }
    
    var minAgeLimit: Int {
        if let minAgeLimit = self.slots.min_age_limit {
            return minAgeLimit
        } else {
            return 0
        }
    }
    
    var availableCapacity: Int {
        if let alc = self.slots.available_capacity {
            return alc
        }
        return 0
    }
    
    var dose1Slots: Int {
        if let dose1Slots = self.slots.available_capacity_dose1 {
            return dose1Slots
        }
        return 0
    }
    
    var dose2Slots: Int {
        if let dose2Slots = self.slots.available_capacity_dose2 {
            return dose2Slots
        }
        return 0
    }
    
}
