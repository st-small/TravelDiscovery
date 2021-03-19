//
//  DiscoverView.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 10.03.2021.
//

import SwiftUI

extension Color {
    static let discoverBackground = Color(white: 0.95, opacity: 1)
    static let defaultBackground = Color("defaultBackground")
    static let tileBackground = Color("tileBackground")
}

struct DiscoverView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9882131219, green: 0.6823856831, blue: 0.2509839535, alpha: 1)), Color(#colorLiteral(red: 0.996080339, green: 0.446325405, blue: 0.2697934847, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.discoverBackground
                    .offset(y: 400)
                
                ScrollView {
                     
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(white: 1, opacity: 0.3))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack {
                        PopularDestinationsView()
                        
                        PopularRestaurantsView()
                        
                        TrendingCreatorsView()
                    }
                    .background(Color.defaultBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                }
            }
            
            .navigationTitle("Discover")
    
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .colorScheme(.dark)
        DiscoverView()
            .colorScheme(.light)
    }
}


