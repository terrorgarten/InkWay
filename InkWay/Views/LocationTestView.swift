//
//  LocationTestView.swift
//  InkWay
//
//  Created by terrorgarten on 30.05.2023.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct LocationTestView: View {
    
    @StateObject private var viewModel = LocationTestViewModel()
    
    var body: some View {
        VStack {
            Text("See your lcoation here :)")
            
            Spacer()
            VStack{
                if !viewModel.cityName.isEmpty {
                    Text(viewModel.cityName)
                } else {
                    Text("Please allow location gathering")
                    LocationButton(.currentLocation) {
                        viewModel.requestAllowOnceLocationPermission()
                    }
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .labelStyle(.titleAndIcon)
                    .symbolVariant(.fill)
                    .tint(.accentColor)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct LocationTestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationTestView()
    }
}
