//
//  PopularRestaurantsView.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 12.03.2021.
//

import SwiftUI

struct PopularRestaurantsView: View {
    
    let restaurants: [Restaurant] = [
        Restaurant(name: "Japan's Finest Tapas", imageName: "tapas"),
        Restaurant(name: "Bar & Grill", imageName: "bar_grill")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Poopular places to eat")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(restaurants, id: \.self) { restaurant in
                        NavigationLink(
                            destination: RestaurantDetailsView(restaurant: restaurant),
                            label: {
                                RestaurantTile(restaurant: restaurant)
                                    .foregroundColor(Color(.label))
                            })
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct RestaurantTile: View {
    
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 8) {
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(5)
                .padding(.leading, 6)
                .padding(.vertical, 6)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(restaurant.name)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    })
                }
                
                HStack {
                    Image(systemName: "star.fill")
                    Text("4.7 • Sushi • $$")
                }
                
                Text("Tokyo, Japan")
            }.font(.system(size: 12, weight: .semibold))
            
            Spacer()
        }
        .frame(width: 240)
        .asTile()
    }
}

struct PopularRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
        PopularRestaurantsView()
    }
}
