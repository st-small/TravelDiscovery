//
//  PopularDestinationsView.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 12.03.2021.
//

import MapKit
import SwiftUI

struct PopularDestinationsView: View {
    
    let destinations: [Destination] = [
        Destination(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.855014, longitude: 2.341231),
        Destination(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.67988, longitude: 139.7695),
        Destination(name: "New York", country: "US", imageName: "new_york", latitude: 40.71592, longitude: -74.0055)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Poopular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(destinations, id: \.self) { destination in
                        NavigationLink(
                            destination:
                                NavigationLazyView(PopularDestinationDetailsView(destination: destination)),
                            label: {
                                PopularDestinationTile(destination: destination)
                                    .padding(.bottom)
                            })
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}

class DestinationDetailsViewModel: ObservableObject {
    
    @Published
    var isLoading = true
    
    @Published
    var destinationDetails: DestinationDetails?
    
    init(name: String) {
        
        let fixedUrlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedUrlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                    
                } catch {
                    print("Failed to decode JSON", error.localizedDescription)
                }
            }
            
        }.resume()
    }
}

struct PopularDestinationDetailsView: View {
    
    @ObservedObject
    var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    init(destination: Destination) {
        self.destination = destination
        
        let center = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        self._region = State(initialValue: MKCoordinateRegion(center: center, span: span))
        
        vm = DestinationDetailsViewModel(name: destination.name)
    }
    
    var body: some View {
        ScrollView {
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: photos)
                    .frame(height: 250)
            }
            
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                
                HStack {
                    Text(vm.destinationDetails?.description ?? "")
                        .padding(.top, 4)
                        .font(.system(size: 14))
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("Location")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                
                Button(action: { isShowingAttractions.toggle() }, label: {
                    Text("\(isShowingAttractions ? "Hide" : "Show") attractions")
                        .font(.system(size: 12, weight: .semibold))
                })
                
                Toggle("", isOn: $isShowingAttractions)
                    .labelsHidden()
            }
            .padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                }
            }
            .frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
    
    let attractions = [
        Attraction(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        Attraction(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        Attraction(name: "Louvre Museum", imageName: "art2", latitude: 48.860288, longitude: 2.337789)
    ]
}

struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(white: 0, opacity: 0.5))
                )
            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                .foregroundColor(.white)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(white: 0, opacity: 0.5))
                )
        }.shadow(radius: 5)
    }
}

struct Attraction: Identifiable {
    let id = UUID()
    let name, imageName: String
    let latitude, longitude: Double
}

struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
        .asTile()
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationDetailsView(destination: Destination(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
        DiscoverView()
        PopularDestinationsView()
            .colorScheme(.dark)
        PopularDestinationsView()
            .colorScheme(.light)
    }
}
