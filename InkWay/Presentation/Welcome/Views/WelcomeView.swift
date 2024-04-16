//
//  WelcomeView.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel = WelcomeViewModel()
    @EnvironmentObject var router: BaseRouter
    @State private var goToRegistration = false
    
    var body: some View {
        VStack {
            Text("Welcome to InkWay")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            Text("...ready for your new tattoos?")
                .italic()
                .foregroundColor(Color.secondary.opacity(0.9))
                .padding(.leading)
            
            Image("AppIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .padding(.top, 20)
            
            VStack{
                Text("Choose which account you would like to create")
                    .font(.headline)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.accentColor)
                IWPrimaryButton(title: "Sign up as user", color: Color.accentColor, action: {
                    viewModel.navigateToRegistration(createTattooerProfile: false)
                })
                
                IWPrimaryButton(title: "Sign up as tattoo artist", color: Color.accentColor, action: {
                    viewModel.navigateToRegistration(createTattooerProfile: true)
                })
                
                
            }
            .padding(.top, 20)
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                Button(action: {router.navigate(to: .login)}) {
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .onChange(of: viewModel.navigateToPath) {
            if let destination = viewModel.navigateToPath {
                viewModel.navigateToPath = nil
                router.navigate(to: destination)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
