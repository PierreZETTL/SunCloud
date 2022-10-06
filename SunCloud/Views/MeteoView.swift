//
//  MeteoView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 06/10/2022.
//

import SwiftUI
import CoreLocation

struct MeteoView: View {
    // Variables d'environnement
    @Environment(\.colorScheme) var colorScheme
    
    // Variable type de vue
    @State var type: String
    
    // Variables position
    @State var cityName = ""
    @State var countryName = ""

    // Récupération infos position
    struct ReversedGeoLocation {
        let city: String
        let country: String
        init(with placemark: CLPlacemark) {
            self.city = placemark.locality ?? ""
            self.country = placemark.country ?? ""
        }
    }
    func reverseGeocode() {
        let location = type != "random" ? CLLocation(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0, longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0) : CLLocation(latitude: CLLocationDegrees(GlobalVars.randLatitude), longitude: CLLocationDegrees(GlobalVars.randLongitude))
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            self.cityName = reversedGeoLocation.city
            self.countryName = reversedGeoLocation.country
            print("Ville : \(reversedGeoLocation.city)")
            print("Pays : \(reversedGeoLocation.country)")
        }
    }
    
    // Variable données météo
    @State var weather: Weather = GlobalVars.defaultWeather
    
    // Variables dates & prévisions
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var currentDay = Calendar.current.component(.weekday, from: Date())
    @State var previsionsbh = [Int]()
    @State var previsionsbd = [Int]()
    let weekdays = [1: "Dimanche", 2: "Lundi", 3: "Mardi", 4: "Mercredi", 5: "Jeudi", 6: "Vendredi", 7: "Samedi"]
    
    // Variable animation fond
    @State private var animateGradient = true
        
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.85), colorScheme != .dark ? .yellow.opacity(0.85) : .orange.opacity(0.85)], startPoint: animateGradient ? .topLeading : .topTrailing, endPoint: animateGradient ? .bottomTrailing : .bottomLeading)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            List {
                Section(header: Spacer(minLength: 0)) {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(countryName != "" ? countryName : "Pays inconnu")")
                                .font(.system(size: 20))
                                .frame(height: 25)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(cityName != "" ? cityName : "Ville inconnue")")
                                .font(.system(size: 30))
                                .frame(height: 35)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.0f", weather.current_weather.temperature))°")
                                .font(.system(size: 100))
                                .fontWeight(.thin)
                                .frame(height: 70)
                            Spacer()
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.blue.opacity(0))
                Section("🕦 Prévisions sur 10 heures") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            Spacer()
                            ForEach(previsionsbh, id: \.self) { i in
                                VStack(alignment: .center) {
                                    if i == currentHour {
                                        Text("Act.")
                                            .frame(width: 50, height: 25, alignment: .center)
                                    } else {
                                        if i > 23 {
                                            Text("\(i-24) h")
                                                .frame(width: 50, height: 25, alignment: .center)
                                        } else {
                                            Text("\(i) h")
                                                .frame(width: 50, height: 25, alignment: .center)
                                        }
                                    }
                                    if weather.hourly.snowfall[i] > 0 {
                                        Image(systemName: "cloud.snow.fill")
                                            .frame(width: 50, height: 25, alignment: .center)
                                            .foregroundColor(Color.white)
                                    } else if weather.hourly.rain[i] > 0 {
                                        Image(systemName: "cloud.rain.fill")
                                            .frame(width: 50, height: 25, alignment: .center)
                                            .foregroundColor(Color.white)
                                    } else if weather.hourly.cloudcover[i] > 0 {
                                        if i < 8 || i > 20 {
                                            Image(systemName: "cloud.moon.fill")
                                                .frame(width: 50, height: 25, alignment: .center)
                                                .foregroundColor(Color.white)
                                        } else {
                                            Image(systemName: "cloud.sun.fill")
                                                .frame(width: 50, height: 25, alignment: .center)
                                                .foregroundColor(Color.yellow)
                                        }
                                    } else {
                                        if i < 8 || i > 20 {
                                            Image(systemName: "moon.stars.fill")
                                                .frame(width: 50, height: 25, alignment: .center)
                                                .foregroundColor(Color.white)
                                        } else {
                                            Image(systemName: "sun.max.fill")
                                                .frame(width: 50, height: 25, alignment: .center)
                                                .foregroundColor(Color.yellow)
                                        }
                                    }
                                    if i == currentHour {
                                        Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                            .frame(width: 50, height: 25, alignment: .center)
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("\(String(format: "%.0f", weather.hourly.temperature_2m[i]))°")
                                            .frame(width: 50, height: 25, alignment: .center)
                                    }
                                }
                            }
                            Spacer()
                        }
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
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 25)
                            }
                            if i == 0 {
                                Text("Aujourd'hui")
                                    .frame(width: 115, height: 25, alignment: .leading)
                                    .fontWeight(.semibold)
                            } else if currentDay+i > 7 {
                                Text(weekdays[currentDay+(i-7)] ?? "Erreur")
                                    .frame(width: 115, height: 25, alignment: .leading)
                            } else {
                                Text(weekdays[currentDay+i] ?? "Erreur")
                                    .frame(width: 115, height: 25, alignment: .leading)
                            }
                            Spacer()
                            if i == 0 {
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                    .frame(width: 45, height: 25, alignment: .trailing)
                                    .fontWeight(.semibold)
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                                    .frame(width: 60, height: 2, alignment: .center)
                                    .cornerRadius(25)
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                                    .frame(width: 45, height: 25, alignment: .leading)
                                    .fontWeight(.semibold)
                            } else {
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_min[i]))°")
                                    .frame(width: 45, height: 25, alignment: .trailing)
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 165/255, green: 210/255, blue: 120/255), Color(red: 255/255, green: 180/255, blue: 0/255)]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                                    .frame(width: 60, height: 2, alignment: .center)
                                    .cornerRadius(25)
                                Text("\(String(format: "%.0f", weather.daily.temperature_2m_max[i]))°")
                                    .frame(width: 45, height:25, alignment: .leading)
                            }
                        }
                    }
                }
                .listRowBackground(Color.blue.opacity(0.65))
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(Color.white)
            
            if type == "random" {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            GlobalVars.setRandoms()
                            WeatherRandomAPI().loadData { (weather) in
                                self.weather = weather
                                self.reverseGeocode()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .imageScale(.large)
                                .frame(width: 35, height: 35, alignment: .center)
                                .background(Color.blue.opacity(0.65))
                                .cornerRadius(15)
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 15)
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            if self.type != "random" {
                CLLocationManager().requestWhenInUseAuthorization()
                WeatherAPI().loadData { (weather) in
                    self.weather = weather
                    self.reverseGeocode()
                    self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4, currentHour+5, currentHour+6, currentHour+7, currentHour+8, currentHour+9]
                    self.previsionsbd = [0, 1, 2, 3, 4, 5, 6]
                }
            } else {
                WeatherRandomAPI().loadData { (weather) in
                    self.weather = weather
                    self.reverseGeocode()
                    self.previsionsbh = [currentHour, currentHour+1, currentHour+2, currentHour+3, currentHour+4, currentHour+5, currentHour+6, currentHour+7, currentHour+8, currentHour+9]
                    self.previsionsbd = [0, 1, 2, 3, 4, 5, 6]
                }
            }
        }
    }
}

struct MeteoView_Previews: PreviewProvider {
    static var previews: some View {
        MeteoView(type: "default")
    }
}
