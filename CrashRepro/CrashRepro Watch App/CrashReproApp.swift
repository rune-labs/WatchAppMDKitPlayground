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
            .onChange(of: scenePhase, perform: { value in
                switch value {
                case .active:
                    DispatchQueue.global().async() {
                        viewModel.refresh()
                    }
                    break
                case .background:
                    break
                case .inactive:
                    break
                @unknown default:
                    break
                }
            })
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
    
    
    public func refresh() {
        print("Thread.current.isMainThread: \(Thread.current.isMainThread)")
        print("SKPaymentQueue.countryCode: \(String(describing: SKPaymentQueue.default().storefront?.countryCode))")
        print("CMMovementDisorderManager.authorizationStatus(): \(CMMovementDisorderManager.authorizationStatus())")
        authStatus = CMMovementDisorderManager.authorizationStatus()
        disorderManager.monitorKinesias(forDuration: 60.0 * 60.0 * 24.0 * 7.0)
        
        print("identifierForVendor: \(String(describing: WKInterfaceDevice.current().identifierForVendor?.uuidString))")
        
        // Often the execution will stop here without a crash. Just can't
        // debug or get a print to show up after this
        
        print("monitorKinesiasExpirationDate: \(String(describing: disorderManager.monitorKinesiasExpirationDate()))")
        kinesiasExpiration = disorderManager.monitorKinesiasExpirationDate()
        print("lastProcessedDate: \(String(describing: disorderManager.lastProcessedDate()))")
        lastProcessed = disorderManager.lastProcessedDate()
        if let lastProcessed = disorderManager.lastProcessedDate() {
            disorderManager.queryDyskineticSymptom(
                from: lastProcessed.addingTimeInterval(-60.0 * 60.0 * 3.0),
                to: lastProcessed) { (dyskineticSymptomResult, error) in
                    self.dyskinesiaResults = dyskineticSymptomResult.count
                    print("queryDyskineticSymptom.dyskineticSymptomResult: \(dyskineticSymptomResult)")
                    print("queryDyskineticSymptom.error: \(String(describing: error))")
                }
            disorderManager.queryTremor(
                from: lastProcessed.addingTimeInterval(-60.0 * 60.0 * 3.0),
                to: lastProcessed) { (tremorSymptomResult, error) in
                    self.tremorResults = tremorSymptomResult.count
                    print("queryTremor.tremorSymptomResult: \(tremorSymptomResult)")
                    print("queryTremor.error: \(String(describing: error))")
            }
        }
    }
}
