//
//  CrashReproApp.swift
//  CrashRepro Watch App
//
//  Created by Bruce Daniel Rune Labs on 8/2/23.
//

import SwiftUI
import WatchKit
import StoreKit
import CoreMotion

@main
struct CrashRepro_Watch_AppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = TestAppViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}

public class TestAppViewModel: ObservableObject {
     let disorderManager = CMMovementDisorderManager()

    @Published private(set) var tremorResults: Int?
    @Published private(set) var dyskinesiaResults: Int?
    @Published private(set) var lastProcessed: Date?
    @Published private(set) var kinesiasExpiration: Date?
    @Published private(set) var authStatus: CMAuthorizationStatus?
    @Published private(set) var vendorID: String?
    @Published private(set) var countryCode: String?
    
    @MainActor
    public func refresh() {
        disorderManager.monitorKinesias(forDuration: 60.0 * 60.0 * 24.0 * 7.0)
        
        print("SKPaymentQueue.countryCode: \(String(describing: SKPaymentQueue.default().storefront?.countryCode))")
        countryCode = SKPaymentQueue.default().storefront?.countryCode

        print("CMMovementDisorderManager.authorizationStatus(): \(CMMovementDisorderManager.authorizationStatus())")
        authStatus = CMMovementDisorderManager.authorizationStatus()
        
        print("identifierForVendor: \(String(describing: WKInterfaceDevice.current().identifierForVendor?.uuidString))")
        vendorID = WKInterfaceDevice.current().identifierForVendor?.uuidString
        // Often the execution will stop here without a crash. Just can't
        // debug or get a print to show up after this

         queryPDSymptoms()
    }
    
    func queryPDSymptoms() {
        DispatchQueue.global().async {
            Task { @MainActor in
                self.kinesiasExpiration = self.disorderManager.monitorKinesiasExpirationDate()
            }
            print("expirationDate: \(String(describing: self.kinesiasExpiration))")

            Task { @MainActor in
                self.lastProcessed = self.disorderManager.lastProcessedDate()
            }
            print("lastProcessedDate: \(String(describing: self.lastProcessed))")
            
            if let lastProcessed = self.disorderManager.lastProcessedDate() {
                self.disorderManager.queryDyskineticSymptom(
                    from: lastProcessed.addingTimeInterval(-60.0 * 60.0 * 3.0),
                    to: lastProcessed) { (dyskineticSymptomResult, error) in
                        Task { @MainActor in
                            self.dyskinesiaResults = dyskineticSymptomResult.count
                        }
                        print("queryDyskineticSymptom.dyskineticSymptomResult: \(dyskineticSymptomResult)")
                        print("queryDyskineticSymptom.error: \(String(describing: error))")
                    }
                self.disorderManager.queryTremor(
                    from: lastProcessed.addingTimeInterval(-60.0 * 60.0 * 3.0),
                    to: lastProcessed) { (tremorSymptomResult, error) in
                        Task { @MainActor in
                            self.tremorResults = tremorSymptomResult.count
                        }
                        print("queryTremor.tremorSymptomResult: \(tremorSymptomResult)")
                        print("queryTremor.error: \(String(describing: error))")
                    }
            }
        }
    }
}
