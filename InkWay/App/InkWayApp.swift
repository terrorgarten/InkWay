//
//  InkWayApp.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // MARK: firebase setup
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
                        case .createTattooerProfile:
                            CreateTattooerProfileView()
                        case .welcome:
                            WelcomeView()
                        case .onboarding:
                            OnboardingView()
                        case .home:
                            MainView()
                        case .none:
                            EmptyView()
                        }
                    }
            }
            .environmentObject(router)
            .accentColor(.mint)
        }
    }
}
