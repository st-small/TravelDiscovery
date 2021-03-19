//
//  DiscoverCategoriesView.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 12.03.2021.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct DiscoverCategoriesView: View {
    
    let categories: [Category] = [
        Category(name: "Art", imageName: "paintpalette.fill"),
        Category(name: "Sports", imageName: "sportscourt.fill"),
        Category(name: "Live Events", imageName: "music.mic"),
        Category(name: "Food", imageName: "tray.fill"),
        Category(name: "History", imageName: "books.vertical.fill")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                ForEach(categories, id: \.self) { categoory in
                    NavigationLink(
                        destination: NavigationLazyView(CategoryDetailsView(name: categoory.name)),
                        label: {
                            VStack(spacing: 8) {
                                Image(systemName: categoory.imageName)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.5058823529, blue: 0.231372549, alpha: 1)))
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .cornerRadius(64)
                                Text(categoory.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }.frame(width: 68)
                        })
                }
                
            }.padding(.horizontal)
        }
    }
}

struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
