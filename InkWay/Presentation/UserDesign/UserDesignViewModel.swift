//
//  UserDesignViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage


// MARK: handles the user uploaded designs
class UserDesignViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var isLoading = false
    private var userId: String = ""
    private var listener: ListenerRegistration?  // for live updates
    
    private let getAllDesignsUseCase = GetAllDesignsUseCase(designsRepository: DesignRepositoryImpl())
    private let getAllPostsUseCase = GetAllPostsUseCase(fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))

    func fetchUserDesigns(for userId: String) {
        isLoading = true
        Task {
            do {
                let resultDesigns = try await getAllDesignsUseCase.execute(with: None())
                let resultPosts = try await getAllPostsUseCase.execute(with: resultDesigns)
                print("Your posts")
                print(resultPosts)
                await MainActor.run {
                    posts = resultPosts
                    isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    
    // deleting design - we must delete the relation and the file itself from storage
    func deleteDesign(withID designID: UUID) {
        let storageRef = Storage.storage().reference().child("designs/\(designID).jpg")
        storageRef.delete { error in
            if let error = error {
                print("Error: Can't delete from storage: \(error.localizedDescription)")
            } else {
                let designRef = Firestore.firestore().collection("designs").document(designID.uuidString)
                designRef.delete { error in
                    if let error = error {
                        print("Error: Can't delete from database: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.posts.removeAll(where: { $0.design.id == designID })
                        }
                    }
                }
            }
        }
    }
    
    
    // just remove listening
    func stopListening() {
        listener?.remove()
    }
    
}
