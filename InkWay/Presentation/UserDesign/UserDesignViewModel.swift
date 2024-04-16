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
    
    private var userId: String = ""
    private var listener: ListenerRegistration?  // for live updates
    
    
    
    // fetch current user info
    func fetchUserDesigns(for userId: String) {
        self.userId = userId
        let query = Firestore.firestore().collection("designs").whereField("userId", isEqualTo: userId)
        listener = query.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error: Can't fetch designs: \(error?.localizedDescription ?? "")")
                return
            }
            // map designs to models
            self.designs = documents.compactMap { document -> DesignModel? in
                try? document.data(as: DesignModel.self)
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
