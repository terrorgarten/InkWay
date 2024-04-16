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
                Section(header: Text("Your name").foregroundColor(Color.mint)){
                    TextField("Name", text: $editedUser.name)
                        .foregroundColor(Color.mint)
                }
                Section(header: Text("Your name").foregroundColor(Color.mint)){
                    TextField("Name", text: $editedUser.surename)
                        .foregroundColor(Color.mint)
                }
                Section(header: Text("Your instagram").foregroundColor(Color.mint)){
                    HStack{
                        Text("@")
                            .foregroundColor(.gray)
                        TextField("Name", text: $editedUser.instagram)
                            .foregroundColor(Color.mint)
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
                        .foregroundColor(Color.mint)
                }),
                trailing: Button(action: {
                    // update call here, explicit
                    viewModel.updateUser(editedUser)
                    isShowingEditView = false
                }, label: {
                    Text("Save")
                        .foregroundColor(Color.mint)
                })
            )
            .foregroundColor(.accentColor)
        }
    }
    
}
