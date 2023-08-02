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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        // disorderManager.monitorKinesias(forDuration: 60.0 * 60.0 * 24.0 * 7.0)
        print("identifierForVendor: \(String(describing: WKInterfaceDevice.current().identifierForVendor?.uuidString))")
        print("SKPaymentQueue.countryCode: \(SKPaymentQueue.default().storefront?.countryCode)")
        // print("CMMovementDisorderManager.authorizationStatus(): \(CMMovementDisorderManager.authorizationStatus())")
        // print("monitorKinesiasExpirationDate: \(String(describing: disorderManager.monitorKinesiasExpirationDate()))")
        // print("lastProcessedDate: \(disorderManager.lastProcessedDate())")
//        disorderManager.queryDyskineticSymptom(from: Date(),
  //                                                    to: Date()) { (dyskineticSymptomResult, error) in
    //        print("queryDyskineticSymptom.dyskineticSymptomResult: \(dyskineticSymptomResult)")
      //      print("queryDyskineticSymptom.error: \(String(describing: error))")
        //}
    }
}
