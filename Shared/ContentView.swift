//
//  ContentView.swift
//  Shared
//
//  Created by Arun Mohan on 15/06/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @ObservedObject var cowinVM: CowinViewModel
    
    var body: some View {
        #if os(macOS)
        WelcomeMacOS(cowinVM: self.cowinVM)
        #else
        WelcomeiOS(cowinVM: self.cowinVM)
        #endif
        
    }
}


struct WelcomeMacOS: View {
    @ObservedObject var cowinVM: CowinViewModel
    var body: some View {
        Section(header: Text("Vaccination Centers in \(cowinVM.districtName)")) {
            Section(header: Text("Vaccination Date: \(self.cowinVM.formatDate(date: self.cowinVM.date))")
                        .foregroundColor(.white)
                        .font(.subheadline)
            ) {
                Text("List refreshes every 10 seconds")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            HStack {
                Text("Center Name")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Address")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Free/Paid")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Minimum Age")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Vaccine Name")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Total Slots")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Dose 1 Slots")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Dose 2 Slots")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            }.background(Color.purple)
            .padding()
        }
        .font(.largeTitle)
        .foregroundColor(.orange)
        List {
                ForEach(self.cowinVM.allSlots) { slot in
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(slot.name)
                            .font(.title2)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 10)
                            
                        Text(slot.address)
                            .font(.body)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(slot.feeType)
                            .font(.title2)
                            .foregroundColor(slot.feeType == "Free" ? .blue : .red)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(slot.minAgeLimit)+")
                            .font(.title2)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(slot.vaccine)")
                            .font(.title2)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .yellow)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(slot.availableCapacity)")
                            .font(.title2)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(slot.dose1Slots)")
                            .font(.title2)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : false))  ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("\(slot.dose2Slots)")
                            .font(.title2)
                            .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? false : slot.dose2Slots > 0))  ? .green : .gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.bottom, 10)
                }
            
        }.onAppear {
            self.cowinVM.fetchDataReqularly()
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_,_) in
                
            }
        }
        .onReceive([self.cowinVM.isUserNeedsToBeNotified].publisher.first()) { value in
            if self.cowinVM.isUserNeedsToBeNotified {
                notifyUser()
            }
        }
    }
}


struct WelcomeiOS: View {
    @ObservedObject var cowinVM: CowinViewModel
    
    #if os(iOS)
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    #endif
    var body: some View {
        #if os(iOS)
        Section(header: Text("Vaccination Date: \(self.cowinVM.formatDate(date: self.cowinVM.date))")
                    .foregroundColor(.purple)
        ) {
            Text("List refreshes every 10 seconds")
                .font(.footnote)
                .foregroundColor(.gray)
        }
            List {
                    ForEach(self.cowinVM.allSlots) { slot in
                        
                        VStack() {
                            HStack {
                                Text(slot.name)
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                                    .font(.custom("Georgia", size: self.idiom == .pad ? 24 : 17, relativeTo: .title3))
                                    .fontWeight(.bold)
                                Text(slot.feeType)
                                    .font(.custom("Georgia", size: self.idiom == .pad ? 18 : 10, relativeTo: .title3))
                                    .foregroundColor(slot.feeType == "Free" ? .blue : .red)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(slot.vaccine)")
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .yellow)
                                    .font(.custom("Georgia", size: self.idiom == .pad ? 20 : 12, relativeTo: .title3))
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                                
                            HStack {
                                Text(slot.address)
                                    .font(.body)
                                    .font(.custom("Georgia", size: self.idiom == .pad ? 20 : 10, relativeTo: .headline))
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                                Spacer()
                                Text("\(slot.minAgeLimit)+")
                                    .foregroundColor(.red)
                                    .font(.custom("Georgia", size: self.idiom == .pad ? 24 : 16, relativeTo: .headline))
                                    .fontWeight(.bold)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            HStack {
                                Text("Total Slots: \(slot.availableCapacity)")
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : slot.dose2Slots > 0))  ? .green : .gray)
                                    .font(.custom("Helvetica Neue Ultra Light", size: self.idiom == .pad ? 20 : 16, relativeTo: .headline))
                                Spacer()
                                Text("Dose 1 slots: \(slot.dose1Slots)")
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? slot.dose1Slots > 0 : false))  ? .green : .gray)
                                    .font(.custom("Helvetica Neue Ultra Light", size: self.idiom == .pad ? 20 : 16, relativeTo: .headline))
                                Spacer()
                                Text("Dose 2 slots: \(slot.dose2Slots)")
                                    .foregroundColor((slot.availableCapacity > 0 && slot.minAgeLimit == self.cowinVM.notificationAgeLimit && (self.cowinVM.notificationDoseLimit == 1 ? false : slot.dose2Slots > 0))  ? .green : .gray)
                                    .font(.custom("Helvetica Neue Ultra Light", size: self.idiom == .pad ? 20 : 16, relativeTo: .headline))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 10)
                    }
                
                    
            }.onAppear {
                self.cowinVM.fetchDataReqularly()
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_,_) in
                    
                }
            }
            .onReceive([self.cowinVM.isUserNeedsToBeNotified].publisher.first()) { value in
                if self.cowinVM.isUserNeedsToBeNotified {
                    notifyUser()
                }
            }
            .navigationBarTitle(Text("Vaccination Centers in \(cowinVM.districtName)"))
            .navigationBarTitleDisplayMode(.inline)
        #endif
        }
}

func notifyUser() {
    let content = UNMutableNotificationContent()
    content.title = "Slots Available"
    content.body = "Please book your slot immediately!!!"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
}
