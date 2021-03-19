//
//  RestaurantDetailsView.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 16.03.2021.
//

import Kingfisher
import SwiftUI

struct RestaurantDetails: Codable {
    let description: String
    let popularDishes: [Dish]
}

struct Dish: Codable, Hashable {
    let name, price, photo: String
    let numPhotos: Int
}

class RestaurantDetailsViewModel: ObservableObject {
    
    @Published
    var isLoading = true
    
    @Published
    var details: RestaurantDetails?
    
    init() {
        
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.details = try? JSONDecoder().decode(RestaurantDetails.self, from: data)
            }
            
        }.resume()
    }
}

struct RestaurantDetailsView: View {
    
    @ObservedObject
    var vm = RestaurantDetailsViewModel()
    
    let restaurant: Restaurant
    
    let sampleDishPhotos = [
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/0d1d2e79-2f10-4cfd-82da-a1c2ab3638d2",
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/3a352f87-3dc1-4fa7-affe-fb12fa8691fe"
    ]
    
    var body: some View {
        ScrollView {
            
            ZStack(alignment: .bottomLeading) {
                Image(restaurant.imageName)
                    .resizable()
                    .scaledToFill()
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            ForEach(0..<5, id: \.self) { num in
                                Image(systemName: "star.fill")
                            }.foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RestaurantPhotosView(),
                        label: {
                            Text("See more foods")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 80)
                                .multilineTextAlignment(.trailing)
                        })
                }
                .padding()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Location & Description")
                    .font(.system(size: 16, weight: .bold))
                
                Text("Tokyo, Japan")
                
                HStack {
                    ForEach(0..<3, id: \.self) { num in
                        Image(systemName: "dollarsign.circle.fill")
                    }.foregroundColor(.orange)
                }
                
                Text(vm.details?.description ?? "")
                    .padding(.top, 8)
                    .font(.system(size: 14, weight: .regular))
                
            }.padding()
            
            HStack {
                Text("Popular Dishes")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
            }.padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.details?.popularDishes ?? [], id: \.self) { dish in
                        DishCell(dish: dish)
                    }
                }.padding(.horizontal)
            }
            
        }.navigationBarTitle("Restaurant details", displayMode: .inline)
    }
}

struct DishCell: View {
    
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                Text(dish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.bottom, 4)
            }.frame(height: 120)
            .cornerRadius(5)
            
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            Text("\(dish.numPhotos) photos")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .regular))
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(restaurant: Restaurant(name: "Japan's Finest Tapas", imageName: "tapas"))
        }
    }
}
