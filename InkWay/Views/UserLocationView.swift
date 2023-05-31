//
//  UserLocationView.swift
//  InkWay
//
//  Created by terrorgarten on 29.05.2023.
//

import SwiftUI


struct UserLocationView: View {
    
    @ObservedObject var viewModel = LocationManager.shared
    
    var body: some View {
        Group {
            // view router
            if viewModel.userLocation == nil {
                UserLocationRequestView()
            } else if let location = viewModel.userLocation {
                Text("\(location)")
                    .padding()
            }
        }
    }
}

struct UserLocationView_Previews: PreviewProvider {
    static var previews: some View {
        UserLocationView()
    }
}
