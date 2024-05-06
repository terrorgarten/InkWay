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
    
    @Published var designs: [DesignModel] = []
    @Published var posts: [PostModel] = posts2
    private var userId: String = ""
    private var listener: ListenerRegistration?  // for live updates
    
    
    
    // fetch current user info
    func fetchUserDesigns(for userId: String) {
        
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
                            self.designs.removeAll(where: { $0.id == designID })
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
