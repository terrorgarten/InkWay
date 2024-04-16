//
//  MainViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation
import FirebaseAuth
import Combine


// main viewmodel, handles the app routing and contect switching
// based on the currentUserArtistStatus
class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var currentUserArtistStatus: Bool = false
        
    private var handler: AuthStateDidChangeListenerHandle?
    public var signedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    private var cancellables = Set<AnyCancellable>()
    private let fetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    public var userProfileViewModel = UserProfileViewModel()
    
    // TODO - remove listener from view model https://stackoverflow.com/questions/67139077/subscribing-to-a-user-variable-from-my-authentication-class-in-an-unrelated-view
    init() {
        userProfileViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.fetchCurrentUser()
            }
            .store(in: &cancellables)
        
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
        fetchCurrentUser()
        do {
            try Auth.auth().signOut()
        } catch {
        }
    }
    
    // loads current user artist status
    func fetchCurrentUser() {
        Task {
            do {
                let user = try await fetchCurrentUserUseCase.execute(with: None())
                self.currentUserArtistStatus = user.artist
            }
            catch(let error) {
                // TODO - handle error
                switch(error) {
                case UserRepositoryError.currentUserNotFound:
                    print()
                case UserRepositoryError.failedToFetchCurrentUser(let error):
                    print()
                case UserRepositoryError.userDataNotFound:
                    print()
                default:
                    print()
                }
            }
        }
    }
    
}
