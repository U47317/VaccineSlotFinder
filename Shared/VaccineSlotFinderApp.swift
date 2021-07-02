//
//  VaccineSlotFinderApp.swift
//  Shared
//
//  Created by Arun Mohan on 18/06/21.
//

import SwiftUI

@main
struct VaccineSlotFinderApp: App {
    var body: some Scene {
        WindowGroup {
            DetailsSelectionView()
        }
        .commands() {
            #if os(macOS)
            SidebarMacOSCommands()
            #endif
        }
    }
}
