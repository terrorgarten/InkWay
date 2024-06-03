//
//  InkWayApp.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // MARK: firebase setup
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
    FirebaseApp.configure()
    return true
  }
}

@main
struct InkWay: App {
  // MARK: app delegate reg
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var router = BaseRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                MainView()
                    .navigationDestination(for: Destination.self) { route in
                        switch route {
                        case .login:
                            LoginView()
                        case .register:
                            RegisterView()
                        case .welcome:
                            WelcomeView()
                        case .onboarding:
                            OnboardingView()
                        case .home:
                            MainView()
                        case .none:
                            EmptyView()
                        case .createUserProfile(let isArtist, let id, let email):
                            CreateUserProfileView(viewModel: CreateUserProfileViewModel(isArtist: isArtist, id: id, email: email))
                        }
                    }
            }
            .environmentObject(router)
            .accentColor(.mint)
        }
    }
}
