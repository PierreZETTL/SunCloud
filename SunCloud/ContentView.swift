//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15]), current_weather: CurrentData(time: "test", temperature: 0.0))
    
    @State var previsions = [Int]()
    
    var body: some View {
        VStack {
            Text("Localisation actuelle")
                .font(.system(size: 25))
                .fontWeight(.semibold)
                .padding(.top)
            Text("\(String(format: "%.0f", weather.current_weather.temperature))°")
                .font(.system(size: 45))
            Text("Coordonnées : \(String(format: "%.2f", weather.latitude)) / \(String(format: "%.2f", weather.longitude))")
                .font(.system(size: 15))
            List {
                Section("Prévisions") {
                    ForEach(previsions, id: \.self) { i in
                        HStack {
                            Text(Date.now+TimeInterval(i*3600), style: .date)
                            Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                .padding(.leading)
                        }
                    }
                }
                .listRowBackground(Color.blue.opacity(0.25))
            }.scrollContentBackground(.hidden)
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            WeatherAPI().loadData { (weather) in
                self.weather = weather
                self.previsions = [24, 48, 72, 96, 120]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
