//
//  SearchView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 07/10/2022.
//

import SwiftUI
import CoreLocation

func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
    CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
}

struct SearchView: View {
    // Variables d'environnement
    @Environment(\.colorScheme) var colorScheme
    
    @State var search = ""
    @State var searched = false
    @FocusState private var focusTF: Bool
    
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
            if !searched {
                VStack(alignment: .center) {
                    Text("Recherche")
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .font(.system(size: 50))
                        .padding(.top, 50)
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.5))
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.white)
                            ZStack(alignment: .leading) {
                                if search.isEmpty {
                                    Text("Nom de ville, pays, ...")
                                        .foregroundColor(Color.white.opacity(0.5))
                                }
                                TextField("", text: $search)
                                    .foregroundColor(Color.white)
                                    .focused($focusTF)
                            }
                        }
                        .padding(.leading, 15)
                    }
                    .frame(height: 40)
                    .cornerRadius(13)
                    .padding(.top, 60)
                    .padding(.horizontal, 25)
                    .onTapGesture {
                        focusTF = true
                    }
                    Spacer()
                    Button {
                        getCoordinateFrom(address: search) { coordinate, error in
                            guard let coordinate = coordinate, error == nil else { return }
                            // don't forget to update the UI from the main thread
                            DispatchQueue.main.async {
                                print(search, "Location:", coordinate) // Rio de Janeiro, Brazil Location: CLLocationCoordinate2D(latitude: -22.9108638, longitude: -43.2045436)
                                GlobalVars.searchLatitude = Float(coordinate.latitude)
                                GlobalVars.searchLongitude = Float(coordinate.longitude)
                                searched = true
                            }
                        }
                    } label: {
                        Text("Valider")
                            .foregroundColor(Color.white)
                            .frame(width: 175, height: 45, alignment: .center)
                            .background(Color.blue.opacity(0.65))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                }
            } else {
                MeteoView(type: "search")
            }
        }
        .onAppear {
            searched = false
            search = ""
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
