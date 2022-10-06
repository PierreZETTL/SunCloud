//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI

class GlobalVars {
    static var randLatitude: Float = 0.0
    static var randLongitude: Float = 0.0
    static var defaultWeather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15], rain: [0.0], cloudcover: [0.0], snowfall: [0.0]), daily: DailyData(time: ["2022-09-30"], temperature_2m_max: [6.5], temperature_2m_min: [4.5], rain_sum: [0.0], snowfall_sum: [0.0], sunrise: ["2022-07-01T18:00"], sunset: ["2022-07-01T06:00"], windspeed_10m_max: [0.0], winddirection_10m_dominant: [0.0]), current_weather: CurrentData(time: "test", temperature: 0.0))
    
    static func setRandoms() {
        GlobalVars.randLatitude = Float.random(in: -84...84)
        GlobalVars.randLongitude = Float.random(in: -179...179)
        
        // Affichage des coordonnées aléatoires
        print("Latitude aléatoire : \(GlobalVars.randLatitude)")
        print("Longitude aléatoire : \(GlobalVars.randLongitude)")
    }
}

struct MainView: View {
    // Configuration pour afficher le fond de la TabView
    let appearance: UITabBarAppearance = UITabBarAppearance()
    init() {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            MeteoView(type: "default")
                .tabItem {
                    Label("Ma position", systemImage: "paperplane.fill")
                }

            MapView()
                .tabItem {
                    Label("Carte", systemImage: "map.fill")
                }

            MeteoView(type: "random")
                .tabItem {
                    Label("Position aléatoire", systemImage: "dice.fill")
                }
        }.onAppear {
            if GlobalVars.randLatitude == 0.0 && GlobalVars.randLongitude == 0.0 {
                GlobalVars.setRandoms()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
