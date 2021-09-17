//
//  FirestoreClient.swift
//  FirestoreClient
//
//  Created by Noah Kamara on 07.09.21.
//

import Foundation
import Firebase

class FirestoreClient {
    private let database: Firestore
    private var collection: CollectionReference {
        return self.database.collection("/testflight-reports")
    }
    
    init() {
        self.database = Firestore.firestore()
    }
    
    public func addDocument(_ data: [String: Any], _ completion: @escaping ((Error?) -> Void)) {
        _ = collection.addDocument(data: data, completion: completion)
    }
}
