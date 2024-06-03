//
//   UserOnboardingSlideshowView.swift
//  InkWay
//
//  Created by terrorgarten on 14.03.2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTab = 0
    @ObservedObject var viewModel = OnboardingViewModel()
    @EnvironmentObject var router: BaseRouter
    
    var slides: [SlideData] = [
        SlideData(heading: "Welcome", description: "Welcome to inkway! The one app that finds you the best tattoo artsits in your area. Anywhere, anytime.", imageName: "star", backgroundColor: Color.blue),
        SlideData(heading: "Lookup designs", description: "Get inspired by our members' designs, which you can filter to find the perfect fit", imageName: "heart.circle", backgroundColor: Color.pink),
        SlideData(heading: "Get new tattoos", description: "Found something you like and the artist is near? Don't be shy and reach out. Our maps are here for you.", imageName: "map", backgroundColor: Color.orange)
    ]

    var body: some View {
        ZStack {
            // Background color to change smoothly with slide change
            Color.clear
                .background(slides[selectedTab].backgroundColor)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.5), value: selectedTab)
            
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        IWOnboardingSlide(slideData: slides[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                
                IWSecondaryButton(title: (selectedTab == slides.count - 1) ? String(localized: "Finish") : String(localized: "Skip"), color: Color.white) {
                    viewModel.finishOnboarding()
                }
                .padding()
                 
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.navigateToPath) { _ in
            if let destination = viewModel.navigateToPath {
                viewModel.navigateToPath = nil
                router.navigate(to: destination)
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
