import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseMessaging

class FirebaseConfig {
    static let shared = FirebaseConfig()
    
    private init() {}
    
    func configure() {
        // Firebase will be configured using GoogleService-Info.plist
        // This will be added when you create your Firebase project
        FirebaseApp.configure()
        
        // Configure Firestore settings
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
    }
}

// MARK: - Firebase Service Protocols
protocol FirebaseService {
    func initialize()
}

// MARK: - Authentication Service
class FirebaseAuthService: FirebaseService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    func initialize() {
        // Authentication is automatically configured when FirebaseApp.configure() is called
    }
    
    // Sign up with email and password
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }
            
            // Create user document in Firestore
            self.createUserDocument(firebaseUser: firebaseUser) { result in
                completion(result)
            }
        }
    }
    
    // Sign in with email and password
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign in failed"])))
                return
            }
            
            // Fetch user document from Firestore
            self.fetchUserDocument(userId: firebaseUser.uid) { result in
                completion(result)
            }
        }
    }
    
    // Sign out
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Get current user
    func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // Create user document in Firestore
    private func createUserDocument(firebaseUser: FirebaseAuth.User, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "id": firebaseUser.uid,
            "email": firebaseUser.email ?? "",
            "name": firebaseUser.displayName ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "lastSeen": FieldValue.serverTimestamp(),
            "isOnline": true
        ]
        
        db.collection("users").document(firebaseUser.uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Create a User object from the data
            let user = User(
                name: firebaseUser.displayName ?? "",
                email: firebaseUser.email ?? "",
                avatar: Avatar(),
                keyLocations: []
            )
            
            completion(.success(user))
        }
    }
    
    // Fetch user document from Firestore
    private func fetchUserDocument(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])))
                return
            }
            
            // Parse user data from Firestore
            let data = document.data() ?? [:]
            let user = User(
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                avatar: Avatar(), // You'll need to decode this properly
                keyLocations: []
            )
            
            completion(.success(user))
        }
    }
}

// MARK: - Firestore Service
class FirebaseFirestoreService: FirebaseService {
    static let shared = FirebaseFirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func initialize() {
        // Firestore is automatically configured when FirebaseApp.configure() is called
    }
    
    // MARK: - Family Management
    func createFamily(name: String, createdBy userId: String, completion: @escaping (Result<Family, Error>) -> Void) {
        let familyData: [String: Any] = [
            "name": name,
            "createdBy": userId,
            "createdAt": FieldValue.serverTimestamp(),
            "members": [userId],
            "inviteCode": generateInviteCode()
        ]
        
        db.collection("families").addDocument(data: familyData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Create a Family object
            let family = Family(
                name: name,
                members: [],
                house: House(rooms: [], furniture: [], theme: .modern),
                virtualPet: nil,
                inviteCode: familyData["inviteCode"] as? String ?? ""
            )
            
            completion(.success(family))
        }
    }
    
    func joinFamily(inviteCode: String, userId: String, completion: @escaping (Result<Family, Error>) -> Void) {
        db.collection("families").whereField("inviteCode", isEqualTo: inviteCode).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(NSError(domain: "FirebaseFirestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Family not found"])))
                return
            }
            
            // Add user to family
            var members = document.data()["members"] as? [String] ?? []
            members.append(userId)
            
            document.reference.updateData(["members": members]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Fetch updated family data
                self.fetchFamily(familyId: document.documentID) { result in
                    completion(result)
                }
            }
        }
    }
    
    func fetchFamily(familyId: String, completion: @escaping (Result<Family, Error>) -> Void) {
        db.collection("families").document(familyId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "FirebaseFirestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Family not found"])))
                return
            }
            
            // Parse family data
            let data = document.data() ?? [:]
            // You'll need to implement proper decoding here
            let family = Family(
                name: data["name"] as? String ?? "",
                members: [],
                house: House(rooms: [], furniture: [], theme: .modern),
                virtualPet: nil,
                inviteCode: data["inviteCode"] as? String ?? ""
            )
            
            completion(.success(family))
        }
    }
    
    // MARK: - Messages
    func sendMessage(familyId: String, message: Message, completion: @escaping (Result<Void, Error>) -> Void) {
        let messageData: [String: Any] = [
            "id": message.id.uuidString,
            "senderId": message.senderId,
            "content": message.content,
            "type": message.type.rawValue,
            "timestamp": FieldValue.serverTimestamp(),
            "isRead": false
        ]
        
        db.collection("families").document(familyId).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func listenToMessages(familyId: String, completion: @escaping ([Message]) -> Void) {
        db.collection("families").document(familyId).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to messages: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let messages = documents.compactMap { document -> Message? in
                    let data = document.data()
                    // You'll need to implement proper decoding here
                    return Message(
                        id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                        senderId: data["senderId"] as? String ?? "",
                        content: data["content"] as? String ?? "",
                        type: MessageType(rawValue: data["type"] as? String ?? "") ?? .text,
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        isRead: data["isRead"] as? Bool ?? false
                    )
                }
                
                completion(messages)
            }
    }
    
    // MARK: - Helper Methods
    private func generateInviteCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
}

// MARK: - Storage Service
class FirebaseStorageService: FirebaseService {
    static let shared = FirebaseStorageService()
    private let storage = Storage.storage()
    
    private init() {}
    
    func initialize() {
        // Storage is automatically configured when FirebaseApp.configure() is called
    }
    
    func uploadAvatarImage(userId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("avatars/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(url?.absoluteString ?? ""))
            }
        }
    }
}
