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
    let disorderManager = CMMovementDisorderManager()
    var body: some Scene {
        WindowGroup {
            Group {
                ContentView()
            }
            .onChange(of: scenePhase, perform: { value in
                DispatchQueue.global().async {
                    switch value {
                    case .active:
                        testAPIs()
                    case .background:
                        break
                    case .inactive:
                        break
                    @unknown default:
                        break
                    }
                }
            })
        }
    }
    
    func testAPIs() {
        disorderManager.monitorKinesias(forDuration: 60.0 * 60.0 * 24.0 * 7.0)
       print("identifierForVendor: \(String(describing: WKInterfaceDevice.current().identifierForVendor?.uuidString))")
       print("SKPaymentQueue.countryCode: \(String(describing: SKPaymentQueue.default().storefront?.countryCode))")
       print("CMMovementDisorderManager.authorizationStatus(): \(CMMovementDisorderManager.authorizationStatus())")
       print("monitorKinesiasExpirationDate: \(String(describing: disorderManager.monitorKinesiasExpirationDate()))")
       print("lastProcessedDate: \(String(describing: disorderManager.lastProcessedDate()))")
       if let lastProcessed = disorderManager.lastProcessedDate() {
           disorderManager.queryDyskineticSymptom(
               from: lastProcessed.addingTimeInterval(-60.0 * 60.0 * 3.0),
               to: lastProcessed) { (dyskineticSymptomResult, error) in
               print("queryDyskineticSymptom.dyskineticSymptomResult: \(dyskineticSymptomResult)")
               print("queryDyskineticSymptom.error: \(String(describing: error))")
           }
       }
    }
}
