//
//  SimpleWeatherAppApp.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 11/8/24.
//

import SwiftUI

@main
struct SimpleWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
       //     ContentView( weatherData: MockWeatherData.sample)
            MinimalisticWeatherView()
        }
    }
}
