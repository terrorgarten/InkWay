//
//  CreateUserProfileView.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//
import SwiftUI
import LocationPicker
import CoreLocation

struct CreateUserProfileView: View {
    @StateObject var viewModel: CreateUserProfileViewModel
    @EnvironmentObject var router: BaseRouter
    @State private var isShowingLocationSheet = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7, longitude: -122.4)
    
    var body: some View {
        NavigationView {
            
            Form {
                
                IWErrorMessageBar(message: viewModel.error)
                
                Section(header: Text("How others see you").foregroundColor(Color.mint)){
                    TextField("Display Name", text: $viewModel.name)
                }
                
                if viewModel.isArtist {
                    Section(header: Text("Your bio").foregroundColor(Color.mint)){
                        // Multi-line input with line wrap
                        TextEditor(text: $viewModel.bio)
                            .frame(minHeight: 100)
                            .lineLimit(4)
                    }
                }
                
                Section(header: Text("Your actual name").foregroundColor(Color.mint)){
                    TextField("John Doe", text: $viewModel.surename)
                }
                
                Section(header: Text("Your Instagram").foregroundColor(Color.mint)){
                    HStack{
                        Text("@")
                            .foregroundColor(.gray)
                        TextField("handle", text: $viewModel.instagram)
                            .autocapitalization(.none)
                    }
                }
                
                if viewModel.isArtist {
                    Section(header: Text("Your location").foregroundColor(Color.mint)){
                        Button(action: {
                            isShowingLocationSheet.toggle()
                        }, label: {
                            if viewModel.coord_x != UserModel.defaultCoordinate && viewModel.coord_y != UserModel.defaultCoordinate
                            || (coordinates.latitude != 37.7 && coordinates.longitude != -122.4){
                                Text("Location selected")
                                    .foregroundColor(.mint)

                            } else {
                                Text("Click to select your location")
                                    .foregroundColor(.mint)
                            }
                        })
                    }
                }
                
                IWPrimaryButton(title: "Create Profile", color: Color.mint) {
                    viewModel.createUserProfile()
                }
            }
        }
        .sheet(isPresented: $isShowingLocationSheet) {
            NavigationView {
                LocationPicker(instructions: "Select your studio location", coordinates: $coordinates)
                    .navigationBarItems(trailing: Button(action: {
                        isShowingLocationSheet.toggle()
                        viewModel.coord_x = Float(coordinates.latitude)
                        viewModel.coord_y = Float(coordinates.longitude)
                    }, label: {
                        Text("Save")
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.mint))
                            .foregroundColor(.white)
                    }))
            }
        }
        .onChange(of: viewModel.navigateToPath) { newPath in
            if let newPath = newPath {
                router.navPath = NavigationPath() // Clear the navigation stack
                router.navPath.append(newPath)
                viewModel.navigateToPath = nil
            }
        }
        .navigationTitle("Create " + (viewModel.isArtist ? "Artist" : "User") + " Profile")
    }
}


struct CreateUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserProfileView(viewModel: CreateUserProfileViewModel(isArtist: true, id: "123", email: "test@example.com"))
    }
}

