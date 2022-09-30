//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15]))
    
    var body: some View {
        VStack {
            Spacer()
            Text("☀️ SunCloud ☁️")
                .font(.system(size: 45))
            
            Spacer()
            Text("Latitude : \(weather.latitude)")
            Text("Longitude : \(weather.longitude)")
            Spacer()
            Text("Température : \(weather.hourly.temperature_2m[0])")
            Text("À : \(weather.hourly.time[0])")
            Spacer()
            Spacer()
        }
        .padding()
        .onAppear {
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
