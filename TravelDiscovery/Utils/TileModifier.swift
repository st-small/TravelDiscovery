//
//  TileModifier.swift
//  TravelDiscovery
//
//  Created by Stanly Shiyanovskiy on 12.03.2021.
//

import SwiftUI

extension View {
    func asTile() -> some View {
        modifier(TileModifier())
    }
}

struct TileModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(Color.tileBackground)
            .cornerRadius(5)
            .shadow(color: Color(.sRGB, white: 0.8, opacity: colorScheme == .light ? 1 : 0), radius: 4, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
    }
}
