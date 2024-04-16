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
        SlideData(heading: "Welcome", description: "Welcome to inkway", imageName: "star", backgroundColor: Color.blue),
        SlideData(heading: "Feature 1", description: "Lorem ipsum placeholder", imageName: "star.fill", backgroundColor:
                    Color.pink)
    ]

    var body: some View {
        ZStack {
            // Background color changes smoothly with slide change
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
                
                
                IWSecondaryButton(title: (selectedTab == slides.count - 1) ? "Finish" : "Skip", color: Color.white) {
                    viewModel.finishOnboarding()
                }
                .padding()
                 
            }
        }
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.navigateToPath) {
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
