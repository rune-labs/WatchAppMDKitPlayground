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
        VStack {
            if let status = viewModel.authStatus {
                Text("CMAuthorizationStatus: \(status.rawValue)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            
            if let lastProcessed = viewModel.lastProcessed {
                Text("Last Processed: \(lastProcessed)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            
            if let expiration = viewModel.kinesiasExpiration {
                Text("Expiration: \(expiration)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            
            if let tremor = viewModel.tremorResults {
                Text("Tremor: \(tremor)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            
            if let dyskinesia = viewModel.dyskinesiaResults {
                Text("Dyskinesia: \(dyskinesia)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
