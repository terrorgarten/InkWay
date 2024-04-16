//
//  CreateUserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

struct CreateTattooerProfileView: View {
    @ObservedObject var viewModel = CreateTattooerProfileViewModel()
    @EnvironmentObject var router: BaseRouter

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Set up your profile")
                    .font(.title)
                    .fontWeight(.bold)
                
                
                IWErrorMessageBar(message: viewModel.errorMessage)
                
                IWFormInputField(placeholder: "How the others see you", value: $viewModel.username, label: "User name",  color: .accentColor)
                
                IWFormInputField(placeholder: "Tell others something about yourself", value: $viewModel.bio, label: "Bio", isMultiline: true, color: Color("SecondaryColor"))

                IWPrimaryButton(title: "Let's go!", color: Color.accentColor, action: router.navigateToRoot)
            }
        }
    }
}

struct CreateUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTattooerProfileView()
    }
}
