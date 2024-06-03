//
//  EditUserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI


// View for editing the user profile
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
                Section(header: Text("How others see you").foregroundColor(Color.mint)){
                    TextField("Display Name", text: $editedUser.name)
                }
                
                if editedUser.artist {
                    Section(header: Text("Your bio").foregroundColor(Color.mint)){
                        TextEditor(text: $editedUser.bio)
                            .frame(minHeight: 100)
                            .lineLimit(4)
                    }
                }
                
                Section(header: Text("Your actual name").foregroundColor(Color.mint)){
                    TextField("John Doe", text: $editedUser.surename)
                }
                Section(header: Text("Your instagram").foregroundColor(Color.mint)){
                    HStack{
                        Text("@")
                            .foregroundColor(.gray)
                        TextField("handle", text: $editedUser.instagram)
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
                        .foregroundColor(Color.red)
                }),
                trailing: Button(action: {
                    // update call here, explicit
                    viewModel.updateUserProfile(user: editedUser)
                    isShowingEditView = false
                }, label: {
                    Text("Save")
                        .foregroundColor(Color.mint)
                        .bold()
                })
            )
        }
    }
    
}
