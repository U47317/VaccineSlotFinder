//
//  DetailsSelectionView.swift
//  CowinApp
//
//  Created by Arun Mohan on 15/06/21.
//

import SwiftUI

struct DetailsSelectionView: View {
    
    @ObservedObject var statesVM = StatesViewModel()
    @State var stateID: Int = 0
    @State var districtID: Int = 0
    @State var date: Date = Date()
    @State var notificationAgeLimit: Int = AgeLimit.Plus18.rawValue
    @State var notificationDoseType: Int = DoseType.Dose1.rawValue
    @State var notificationVaccineType: VaccineType.RawValue = VaccineType.Covisheield.rawValue
    @ObservedObject var districtVM = DistrictsViewModel()
    @ObservedObject var cowinVM : CowinViewModel = CowinViewModel()
   
    var body: some View {
        #if os(macOS)
        DetailsSectionMacOSView(stateID: self.$stateID, districtID: self.$districtID, date: self.$date, notificationAgeLimit: self.$notificationAgeLimit, notificationDoseType: self.$notificationDoseType,notificationVaccineType: self.$notificationVaccineType,districtVM: self.districtVM, cowinVM: self.cowinVM, statesVM: self.statesVM)
        #else
        DetailsSectionIOSView(stateID: self.$stateID, districtID: self.$districtID, date: self.$date,notificationAgeLimit: self.$notificationAgeLimit, notificationDoseType: self.$notificationDoseType,notificationVaccineType: self.$notificationVaccineType, districtVM: self.districtVM, cowinVM: self.cowinVM, statesVM: self.statesVM)
        #endif
        
    }
        
}


struct DetailsSectionIOSView: View {
    @Binding var stateID: Int
    @Binding var districtID: Int
    @Binding var date: Date
    @Binding var notificationAgeLimit: Int
    @Binding var notificationDoseType: Int
    @Binding var notificationVaccineType: VaccineType.RawValue
    @ObservedObject var districtVM : DistrictsViewModel
    @ObservedObject var cowinVM : CowinViewModel
    @ObservedObject var statesVM :StatesViewModel
    var body: some View {
    #if os(iOS)
        NavigationView {
            Form {
                Spacer()
                Picker("Select State:", selection: self.$stateID) {
                    ForEach(self.statesVM.allStates) { eachState in
                        Text(eachState.stateName).tag(eachState.stateID)
                    }
                }
                .onReceive([self.stateID].publisher.first()) { value in

                    if value != 0 && self.stateID != districtVM.stateID {
                        districtVM.stateID = value
                        districtVM.fetchDistrictListData()
                    }
                }.padding()
                Picker("Select District:", selection: self.$districtID) {
                    ForEach(self.districtVM.allDistricts) { eachDistrict in
                        Text(eachDistrict.districtName).tag(eachDistrict.districtID)
                    }
                }.onReceive([self.districtID].publisher.first()) { value in
                    if value != 0 && self.districtID != self.cowinVM.districID {
                        self.cowinVM.districID = value
                        
                        for index in 0..<self.districtVM.allDistricts.count {
                            if self.districtVM.allDistricts[index].districtID == value {
                                self.cowinVM.districtName = self.districtVM.allDistricts[index].districtName
                            }
                        }
                        
                        self.cowinVM.fetchVaccineData()
                    }
                }.padding()
                DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                ).onReceive([self.date].publisher.first(), perform: { value in
                    if value != self.cowinVM.date {
                    self.cowinVM.date = value
                    self.cowinVM.fetchVaccineData()
                    }
                })
                .padding()
                Picker("Age limit:", selection: self.$notificationAgeLimit) {
                    Text("\(AgeLimit.Plus18.rawValue)").tag(AgeLimit.Plus18.rawValue)
                    Text("\(AgeLimit.Plus45.rawValue)").tag(AgeLimit.Plus45.rawValue)
                }
                .onReceive([self.notificationAgeLimit].publisher.first(), perform: { value in
                    if self.cowinVM.notificationAgeLimit != value {
                        self.cowinVM.notificationAgeLimit = value
                    }
                })
                .padding()
                Picker("Dose type:", selection: self.$notificationDoseType) {
                    Text("\(DoseType.Dose1.rawValue)").tag(DoseType.Dose1.rawValue)
                    Text("\(DoseType.Dose2.rawValue)").tag(DoseType.Dose2.rawValue)
                }
                .onReceive([self.notificationDoseType].publisher.first(), perform: { value in
                    if self.cowinVM.notificationDoseLimit != value {
                        self.cowinVM.notificationDoseLimit = value
                    }
                })
                .padding()
                Picker("Vaccine type:", selection: self.$notificationVaccineType) {
                    Text("\(VaccineType.Covaxin.rawValue)").tag(VaccineType.Covaxin.rawValue)
                    Text("\(VaccineType.Covisheield.rawValue)").tag(VaccineType.Covisheield.rawValue)
                }.onReceive([self.notificationVaccineType].publisher.first(), perform: { value in
                    if self.cowinVM.notificationVaccineType != value {
                        self.cowinVM.notificationVaccineType = value
                    }
                })
                .padding()
                NavigationLink(destination: ContentView(cowinVM: self.cowinVM)) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Submit")
                            .foregroundColor(.white)
                    })
                }.padding()
                .background(Color.blue)
            }
            .navigationBarTitle("Get Vaccinated India")
        }
        #endif
    }
}

struct DetailsSectionMacOSView: View {
    
    @Binding var stateID: Int
    @Binding var districtID: Int
    @Binding var date: Date
    @Binding var notificationAgeLimit: Int
    @Binding var notificationDoseType: Int
    @Binding var notificationVaccineType: VaccineType.RawValue
    @ObservedObject var districtVM : DistrictsViewModel
    @ObservedObject var cowinVM : CowinViewModel
    @ObservedObject var statesVM :StatesViewModel

    
    var body: some View {
        NavigationView {
        HStack {
                List {
                    Text("Please select following:")
                    Picker("Select State:", selection: self.$stateID) {
                        ForEach(self.statesVM.allStates) { eachState in
                            Text(eachState.stateName).tag(eachState.stateID)
                        }
                    }
                    .onReceive([self.stateID].publisher.first()) { value in

                        if value != 0 && self.stateID != districtVM.stateID {
                            districtVM.stateID = value
                            districtVM.fetchDistrictListData()
                        }
                    }.padding()
                    Picker("Select District:", selection: self.$districtID) {
                        ForEach(self.districtVM.allDistricts) { eachDistrict in
                            Text(eachDistrict.districtName).tag(eachDistrict.districtID)
                        }
                    }.onReceive([self.districtID].publisher.first()) { value in
                        if value != 0 && self.districtID != self.cowinVM.districID {
                            self.cowinVM.districID = value
                            
                            for index in 0..<self.districtVM.allDistricts.count {
                                if self.districtVM.allDistricts[index].districtID == value {
                                    self.cowinVM.districtName = self.districtVM.allDistricts[index].districtName
                                }
                            }
                            
                            self.cowinVM.fetchVaccineData()
                        }
                    }.padding()
                    DatePicker(
                            "Date",
                            selection: $date,
                            displayedComponents: [.date]
                    ).onReceive([self.date].publisher.first(), perform: { value in
                        if value != self.cowinVM.date {
                        self.cowinVM.date = value
                        self.cowinVM.fetchVaccineData()
                        }
                    })
                    .padding()
                    Picker("Age limit:", selection: self.$notificationAgeLimit) {
                        Text("\(AgeLimit.Plus18.rawValue)").tag(AgeLimit.Plus18.rawValue)
                        Text("\(AgeLimit.Plus45.rawValue)").tag(AgeLimit.Plus45.rawValue)
                    }
                    .onReceive([self.notificationAgeLimit].publisher.first(), perform: { value in
                        if self.cowinVM.notificationAgeLimit != value {
                            self.cowinVM.notificationAgeLimit = value
                        }
                    })
                    .padding()
                    Picker("Dose type:", selection: self.$notificationDoseType) {
                        Text("\(DoseType.Dose1.rawValue)").tag(DoseType.Dose1.rawValue)
                        Text("\(DoseType.Dose2.rawValue)").tag(DoseType.Dose2.rawValue)
                    }
                    .onReceive([self.notificationDoseType].publisher.first(), perform: { value in
                        if self.cowinVM.notificationDoseLimit != value {
                            self.cowinVM.notificationDoseLimit = value
                        }
                    })
                    .padding()
                    Picker("Vaccine type:", selection: self.$notificationVaccineType) {
                        Text("\(VaccineType.Covaxin.rawValue)").tag(VaccineType.Covaxin.rawValue)
                        Text("\(VaccineType.Covisheield.rawValue)").tag(VaccineType.Covisheield.rawValue)
                    }.onReceive([self.notificationVaccineType].publisher.first(), perform: { value in
                        if self.cowinVM.notificationVaccineType != value {
                            self.cowinVM.notificationVaccineType = value
                        }
                    })
                    .padding()
                    NavigationLink(destination: ContentView(cowinVM: self.cowinVM)) {
                        Text("Submit")
                            .cornerRadius(10)
                    
                    }
                    .padding()
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 300)
            
        }
        }
        .frame(minWidth: 1000)
        
    }
}


