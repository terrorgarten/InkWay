//
//  BaseView.swift
//  InkWay
//
//  Created by Oliver Bajus on 15.04.2024.
//

import Foundation
import SwiftUI

struct BaseView: View {
    @EnvironmentObject var viewModel: BaseViewModel
    @State private var navDestination: NavigationDestination = .none
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: buildNextView(),
                    tag: navDestination,
                    selection: $viewModel.navDestination,
                    label: { EmptyView() }
                )
            }
            .onChange(of: viewModel.navDestination) { newValue in
                guard let newNavDestination = newValue else {
                    navDestination = .none
                    return
                }
                navDestination = newNavDestination
            }
        }
    }
    
    @ViewBuilder
    private func buildNextView() -> some View {
        switch navDestination {
        case .login(let vm):
            LoginView().environmentObject(vm)
        case .register(let vm):
            RegisterView().environmentObject(vm)
        case .createTattooerProfile(vm: let vm):
            CreateTattooerProfileView().environmentObject(vm)
        case .welcome(vm: let vm):
            WelcomeView().environmentObject(vm)
        case .onboarding(vm: let vm):
            OnboardingView().environmentObject(vm)
        case .home(vm: let vm):
            MainView().environmentObject(vm)
        case .none:
            EmptyView()
        }
    }
}
