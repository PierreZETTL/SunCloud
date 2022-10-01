//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var cityName = ""
    
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
    
    
    @State var weather: Weather = Weather(latitude: 10.0, longitude: 10.0, hourly: HourlyData(time: ["2022-07-01T00:00"], temperature_2m: [15], rain: [0.0], cloudcover: [0.0], snowfall: [0.0]), daily: DailyData(time: ["2022-09-30"], temperature_2m_max: [6.5], temperature_2m_min: [4.5], rain_sum: [0.0], snowfall_sum: [0.0]), current_weather: CurrentData(time: "test", temperature: 0.0))
    
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var currentDay = Calendar.current.component(.weekday, from: Date())
    @State var previsionsbh = [Int]()
    @State var previsionsbd = [Int]()
    
    let weekdays = [1: "Dimanche", 2: "Lundi", 3: "Mardi", 4: "Mercredi", 5: "Jeudi", 6: "Vendredi", 7: "Samedi"]
    
    @State private var animateGradient = true
        
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.85), colorScheme != .dark ? .yellow.opacity(0.85) : .orange.opacity(0.85)], startPoint: animateGradient ? .topTrailing : .bottomTrailing, endPoint: animateGradient ? .bottomLeading : .topLeading)
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.linear(duration: 50.0).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
                VStack {
                    List {
                        HStack {
                            Spacer()
                            Text("\(cityName != "" ? cityName : "Emplacement inconnu")")
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
                        Section("🕦 Prévisions sur 5 heures") {
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
                                        if weather.hourly.snowfall[i] > 0 {
                                            Image(systemName: "cloud.snow.fill")
                                                .padding(.horizontal, 10.0)
                                                .padding(.vertical, 1.0)
                                                .foregroundColor(Color.white)
                                        } else if weather.hourly.rain[i] > 0 {
                                            Image(systemName: "cloud.rain.fill")
                                                .padding(.horizontal, 10.0)
                                                .padding(.vertical, 1.0)
                                                .foregroundColor(Color.white)
                                        } else if weather.hourly.cloudcover[i] > 0 {
                                            if i < 8 || i > 20 {
                                                Image(systemName: "cloud.moon.fill")
                                                    .padding(.horizontal, 10.0)
                                                    .padding(.vertical, 1.0)
                                                    .foregroundColor(Color.white)
                                            } else {
                                                Image(systemName: "cloud.sun.fill")
                                                    .padding(.horizontal, 10.0)
                                                    .padding(.vertical, 1.0)
                                                    .foregroundColor(Color.yellow)
                                            }
                                        } else {
                                            if i < 8 || i > 20 {
                                                Image(systemName: "moon.stars.fill")
                                                    .padding(.horizontal, 10.0)
                                                    .padding(.vertical, 1.0)
                                                    .foregroundColor(Color.white)
                                            } else {
                                                Image(systemName: "sun.max.fill")
                                                    .padding(.horizontal, 10.0)
                                                    .padding(.vertical, 1.0)
                                                    .foregroundColor(Color.yellow)
                                            }
                                        }
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
                        .listRowBackground(Color.blue.opacity(0.65))
                        Section("📆 Prévisions sur 7 jours") {
                            ForEach(previsionsbd, id: \.self) { i in
                                HStack {
                                    if weather.daily.snowfall_sum[i] > 0 {
                                        Image(systemName: "cloud.snow.fill")
                                            .foregroundColor(Color.white)
                                            .frame(width: 25)
                                    } else if weather.daily.rain_sum[i] > 0 {
                                        Image(systemName: "cloud.rain.fill")
                                            .foregroundColor(Color.white)
                                            .frame(width: 25)
                                    } else {
                                        Image(systemName: "sun.max.fill")
                                            .frame(width: 25)
                                            .foregroundColor(Color.yellow)
                                    }
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
                        .listRowBackground(Color.blue.opacity(0.65))
                    }.scrollContentBackground(.hidden)
                    HStack {
                        Spacer()
                        NavigationLink(destination: RandomView()) {
                            Image(systemName: "dice.fill")
                                .padding(.bottom, 5.0)
                        }
                        Spacer()
                        Button {
                            print("Test")
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .padding(.bottom, 5.0)
                        }
                        Spacer()
                    }
                }
                .foregroundColor(Color.white)
                .navigationBarTitle("Loc. actuelle")
                .navigationBarHidden(true)
            }
        }.accentColor(.white)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
