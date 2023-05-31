//
//  UserHomeView.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import SwiftUI

struct UserHomeView: View {
    
    // @Binding var location_y: Float
    // @Binding var location_x: Float
    
    var body: some View {
        NavigationView {
            VStack {
                // UserMapView()
            }
            .navigationTitle("Welcome home!")
        }
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView()
    }
}
