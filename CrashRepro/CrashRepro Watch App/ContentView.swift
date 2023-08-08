//
//  ContentView.swift
//  CrashRepro Watch App
//
//  Created by Bruce Daniel Rune Labs on 8/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: TestAppViewModel

    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    viewModel.refresh()
                }) {
                    Text("Fetch MDKit")
                }

                if let vendor = viewModel.vendorID {
                    Text("VendorID: \(vendor)")
                }

                if let countryCode = viewModel.countryCode {
                    Text("Country Code: \(countryCode)")
                }

                if let status = viewModel.authStatus {
                    Text("CMAuthorizationStatus: \(status.rawValue)")
                }

                if let lastProcessed = viewModel.lastProcessed {
                    Text("Last Processed: \(lastProcessed)")
                }

                if let expiration = viewModel.kinesiasExpiration {
                    Text("Expiration: \(expiration)")
                }

                if let tremor = viewModel.tremorResults {
                    Text("Tremor: \(tremor)")
                }

                if let dyskinesia = viewModel.dyskinesiaResults {
                    Text("Dyskinesia: \(dyskinesia)")
                }
            }
        }
    }
}
