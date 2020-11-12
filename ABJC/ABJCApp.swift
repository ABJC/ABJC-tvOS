//
//  ABJCApp.swift
//  ABJC
//
//  Created by Noah Kamara on 11.11.20.
//

import SwiftUI

import abjc_core
import abjc_ui
import abjc_api

import URLImage
import os

@main
struct ABJCApp: App {
    
    /// SessionStore
    private let session: SessionStore = SessionStore()
    
    /// PlayerStore
    private let playerStore: PlayerStore = PlayerStore()
    
    /// DesignConfiguration
    private var designConfig: DesignConfiguration {
        let designConfig = DesignConfiguration(.atv)
        return designConfig
    }
    
    /// URLImageOptions
    private var options: URLImageOptions {
        var options = URLImageOptions()
        options.cachePolicy = .returnCacheElseLoad(cacheDelay: 0.5, downloadDelay: 0.5)
        options.expiryInterval = 604800
        return options
    }
    
    var body: some Scene {
        WindowGroup {
            MainViewContainer()
                .environmentObject(session)
                .environmentObject(playerStore)
                .environmentObject(designConfig)
        }
    }
}
