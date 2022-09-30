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
    
    @State var previsionsbh = [Int]()
        
    var body: some View {
        ZStack {
            Color.blue.opacity(0.05)
                .ignoresSafeArea()
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
                    Section("🕦 Prévisions sur 4 heures") {
                        HStack(alignment: .center) {
                            Spacer()
                            ForEach(previsionsbh, id: \.self) { i in
                                VStack(alignment: .center) {
                                    if i == Calendar.current.component(.hour, from: Date()) {
                                        Text("Act.")
                                            .padding(.horizontal, 10.0)
                                    } else {
                                        Text("\(i) h")
                                            .padding(.horizontal, 10.0)
                                    }
                                    Image(systemName: "cloud.sun.fill")
                                        .padding(.horizontal, 10.0)
                                        .padding(.vertical, 1.0)
                                    Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                        .padding(.horizontal, 10.0)
                                }
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue.opacity(0.15))
                    Section("📆 Prévisions sur 5 jours") {
                        Text("Test")
                        Text("Test")
                    }
                    .listRowBackground(Color.blue.opacity(0.15))
                }.scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            WeatherAPI().loadData { (weather) in
                self.weather = weather
                self.previsionsbh = [Calendar.current.component(.hour, from: Date()), Calendar.current.component(.hour, from: Date())+1, Calendar.current.component(.hour, from: Date())+2, Calendar.current.component(.hour, from: Date())+3, Calendar.current.component(.hour, from: Date())+4]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
