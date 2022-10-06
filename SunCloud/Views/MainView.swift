//
//  ContentView.swift
//  SunCloud
//
//  Created by Pierre ZETTL on 29/09/2022.
//

import SwiftUI
import CoreLocation

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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
