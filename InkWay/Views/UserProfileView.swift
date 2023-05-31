//
//  UserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import SwiftUI


struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    @State private var isShowingEditView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        VStack(alignment: .leading) {
                            List {
                                HStack {
                                    Text("Name:")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(user.name)
                                }
                                HStack {
                                    Text("Surename:")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(user.surename)
                                }
                                HStack {
                                    Text("Instagram:")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("@")
                                        .foregroundColor(.gray)
                                        .offset(x: 6)
                                    Text(user.instagram)
                                }
                            }
                            
                            HStack {
                                Text("You are here since:")
                                Spacer()
                                Text(user.joined.formattedDate())
                            }
                            .foregroundColor(.gray)
                            .padding()
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    viewModel.logout()
                                }, label: {
                                    Text("Log me out")
                                })
                                .tint(.red)
                                .padding()
                                
                                Spacer()
                                
                                Button(action: {
                                    isShowingEditView = true
                                }, label: {
                                    Text("Edit")
                                })
                                .tint(.accentColor)
                                .padding()
                            }
                            .padding()
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                    Text("Loading your profile...")
                        .padding()
                }
            }
            .navigationTitle("My profile")
            .sheet(isPresented: $isShowingEditView) {
                if let user = viewModel.user {
                    EditUserProfileView(user: user, isShowingEditView: $isShowingEditView, viewModel: viewModel)
                }
            }
            .onAppear(perform: viewModel.fetchCurrentUser)
        }
    }
}

struct EditUserProfileView: View {
    @State private var editedUser: UserModel
    @Binding var isShowingEditView: Bool
    let viewModel: UserProfileViewModel
    
    init(user: UserModel, isShowingEditView: Binding<Bool>, viewModel: UserProfileViewModel) {
        _editedUser = State(initialValue: user)
        _isShowingEditView = isShowingEditView
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your name")){
                    TextField("Name", text: $editedUser.name)
                }
                Section(header: Text("Your name")){
                    TextField("Name", text: $editedUser.surename)
                }
                Section(header: Text("Your instagram")){
                    HStack{
                        Text("@")
                            .foregroundColor(.gray)
                        TextField("Name", text: $editedUser.instagram)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button(action: {
                    isShowingEditView = false
                }, label: {
                    Text("Cancel")
                }),
                trailing: Button(action: {
                    viewModel.updateUser(editedUser)
                    isShowingEditView = false
                }, label: {
                    Text("Save")
                })
            )
        }
    }
}

