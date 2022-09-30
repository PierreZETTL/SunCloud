//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var cityName = "Erreur : Position introuvable"
    
    func reverseGeocode() {
        let location = CLLocation(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            print(reversedGeoLocation.city)
            self.cityName = reversedGeoLocation.city
        }
    }
    
    struct ReversedGeoLocation {
        let city: String
        
        init(with placemark: CLPlacemark) {
            self.city = placemark.locality ?? ""
        }
    }
    
    
    @State var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15]), daily: DailyData(time: ["2022-09-30"], temperature_2m_max: [6.5], temperature_2m_min: [4.5]), current_weather: CurrentData(time: "test", temperature: 0.0))
    
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var currentDay = Calendar.current.component(.weekday, from: Date())
    @State var previsionsbh = [Int]()
    @State var previsionsbd = [Int]()
    
    let weekdays = [1: "Dimanche", 2: "Lundi", 3: "Mardi", 4: "Mercredi", 5: "Jeudi", 6: "Vendredi", 7: "Samedi"]
        
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.85)
                    .ignoresSafeArea()
                VStack {
                    List {
                        HStack {
                            Spacer()
                            Text("\(cityName)")
                                .font(.system(size: 30))
                                .frame(height: 35)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.blue.opacity(0))
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.0f", weather.current_weather.temperature))°")
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .frame(height: 70)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.blue.opacity(0))
                        Section("🕦 Prévisions sur 4 heures") {
                            HStack(alignment: .center) {
                                Spacer()
                                ForEach(previsionsbh, id: \.self) { i in
                                    VStack(alignment: .center) {
                                        if i == currentHour {
                                            Text("Act.")
                                                .padding(.horizontal, 9.0)
                                                .fontWeight(.semibold)
                                        } else {
                                            if i > 24 {
                                                Text("\(i-24) h")
                                                    .padding(.horizontal, 9.0)
                                            } else {
                                                Text("\(i) h")
                                                    .padding(.horizontal, 9.0)
                                            }
                                        }
                                        Image(systemName: "cloud.sun.fill")
                                            .padding(.horizontal, 10.0)
                                            .padding(.vertical, 1.0)
                                            .foregroundColor(Color.yellow)
                                        if i == currentHour {
                                            Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                                .padding(.horizontal, 10.0)
                                                .fontWeight(.semibold)
                                        } else {
                                            Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                                .padding(.horizontal, 10.0)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.blue.opacity(0.9))
                        Section("📆 Prévisions sur 7 jours") {
                            ForEach(previsionsbd, id: \.self) { i in
                                HStack {
                                    Image(systemName: "cloud.sun.fill")
                                        .foregroundColor(Color.yellow)
                                    if i == 0 {
                                        Text("Aujourd'hui")
                                            .fontWeight(.semibold)
                                    } else if currentDay+i > 7 {
                                        Text(weekdays[currentDay+(i-7)] ?? "Erreur")
                                    } else {
                                        Text(weekdays[currentDay+i] ?? "Erreur")
                                    }
                                    Spacer()
                                    if i == 0 {
                                        Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                            .fontWeight(.semibold)
                                        Rectangle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                                            .frame(width: 60, height: 2)
                                            .cornerRadius(25)
                                        Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                        Rectangle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                                            .frame(width: 60, height: 2)
                                            .cornerRadius(25)
                                        Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.blue.opacity(0.9))
                    }.scrollContentBackground(.hidden)
                    Text("Coordonnées : \(String(format: "%.2f", weather.latitude)) / \(String(format: "%.2f", weather.longitude))")
                        .font(.system(size: 15))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5.0)
                }
                .foregroundColor(Color.white)
            }
        }
        
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
            WeatherAPI().loadData { (weather) in
                self.weather = weather
                self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4]
                self.previsionsbd = [0, 1, 2, 3, 4, 5, 6]
                
                self.reverseGeocode()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
