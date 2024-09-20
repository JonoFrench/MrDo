//
//  MrDoApp.swift
//  MrDo
//
//  Created by Jonathan French on 17.09.24.
//

import SwiftUI

@main
struct MrDoApp: App {
    @StateObject private var manager = GameManager()
    var body: some Scene {
#if os(iOS)
        WindowGroup {
            ContentView().environmentObject(manager)
        }
#elseif os(tvOS)
        WindowGroup {
            ContentViewTV().environmentObject(manager)
                .background(.black)
        }
#endif
    }
}
