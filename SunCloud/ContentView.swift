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
    
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var previsionsbh = [Int]()
        
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                Text("Localisation actuelle")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .padding(.top, 25.0)
                    .padding(.bottom, 1.0)
                Text("\(String(format: "%.0f", weather.current_weather.temperature))°")
                    .font(.system(size: 60))
                    .fontWeight(.semibold)
                List {
                    Section("🕦 Prévisions sur 4 heures") {
                        HStack(alignment: .center) {
                            Spacer()
                            ForEach(previsionsbh, id: \.self) { i in
                                VStack(alignment: .center) {
                                    if i == currentHour {
                                        Text("Act.")
                                            .padding(.horizontal, 10.0)
                                            .foregroundColor(Color.white)
                                    } else {
                                        Text("\(i) h")
                                            .padding(.horizontal, 10.0)
                                            .foregroundColor(Color.white)
                                    }
                                    Image(systemName: "cloud.sun.fill")
                                        .padding(.horizontal, 10.0)
                                        .padding(.vertical, 1.0)
                                        .foregroundColor(Color.yellow)
                                    Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                        .padding(.horizontal, 10.0)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.semibold)
                                }
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue.opacity(0.7))
                    Section("📆 Prévisions sur 5 jours") {
                        Text("Test")
                            .foregroundColor(Color.white)
                        Text("Test")
                            .foregroundColor(Color.white)
                    }
                    .listRowBackground(Color.blue.opacity(0.7))
                }.scrollContentBackground(.hidden)
                Text("Coordonnées : \(String(format: "%.2f", weather.latitude)) / \(String(format: "%.2f", weather.longitude))")
                    .font(.system(size: 15))
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            WeatherAPI().loadData { (weather) in
                self.weather = weather
                self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
