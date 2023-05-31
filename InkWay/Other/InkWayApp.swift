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
  var body: some Scene {
    WindowGroup {
      NavigationView {
        MainView()
              .accentColor(.mint)
      }
    }
  }
}
