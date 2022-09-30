//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15]))
    
    var body: some View {
        VStack {
            Text("☀️ SunCloud ☁️")
                .font(.system(size: 45))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top)
            List {
                Section("Coordonnées") {
                    Text("Latitude : \(weather.latitude)")
                    Text("Longitude : \(weather.longitude)")
                }
                Section("Conditions actuelles") {
                    Text("Température : \(weather.hourly.temperature_2m[0])")
                }
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            WeatherAPI().loadData { (weather) in
                self.weather = weather
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
