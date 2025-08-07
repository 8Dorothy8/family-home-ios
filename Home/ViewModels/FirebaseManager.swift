import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import Combine

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    // Services
    private let authService = FirebaseAuthService.shared
    private let firestoreService = FirebaseFirestoreService.shared
    private let storageService = FirebaseStorageService.shared
    
    // Published properties
    @Published var currentUser: User?
    @Published var currentFamily: Family?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Listeners
    private var familyListener: ListenerRegistration?
    private var messagesListener: ListenerRegistration?
    
    private init() {
        setupAuthStateListener()
    }
    
    // MARK: - Initialization
    func configure() {
        FirebaseConfig.shared.configure()
        authService.initialize()
        firestoreService.initialize()
        storageService.initialize()
    }
    
    // MARK: - Authentication State Listener
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.isAuthenticated = true
                    self?.fetchUserData(userId: user.uid)
                } else {
                    self?.isAuthenticated = false
                    self?.currentUser = nil
                    self?.currentFamily = nil
                    self?.removeListeners()
                }
            }
        }
    }
    
    // MARK: - Authentication
    func signUp(name: String, email: String, password: String, avatar: Avatar, completion: @escaping (Result<User, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        authService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(var user):
                    user.name = name
                    user.avatar = avatar
                    self?.currentUser = user
                    self?.saveUserData(user: user) { saveResult in
                        switch saveResult {
                        case .success:
                            completion(.success(user))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        authService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.fetchFamilyData(for: user)
                    completion(.success(user))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
            currentUser = nil
            currentFamily = nil
            isAuthenticated = false
            removeListeners()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - User Data
    private func fetchUserData(userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User document not found")
                return
            }
            
            let data = document.data() ?? [:]
            let user = User(
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                avatar: Avatar(), // You'll need to decode this properly
                keyLocations: []
            )
            
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.fetchFamilyData(for: user)
            }
        }
    }
    
    private func saveUserData(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = authService.getCurrentUser() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
            return
        }
        
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "id": currentUser.uid,
            "name": user.name,
            "email": user.email,
            "avatar": try? JSONEncoder().encode(user.avatar),
            "keyLocations": [],
            "lastSeen": FieldValue.serverTimestamp(),
            "isOnline": true
        ]
        
        db.collection("users").document(currentUser.uid).setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Family Management
    func createFamily(name: String, completion: @escaping (Result<Family, Error>) -> Void) {
        guard let currentUser = authService.getCurrentUser() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        firestoreService.createFamily(name: name, createdBy: currentUser.uid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let family):
                    self?.currentFamily = family
                    self?.setupFamilyListener(familyId: family.id?.uuidString ?? "")
                    completion(.success(family))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    func joinFamily(inviteCode: String, completion: @escaping (Result<Family, Error>) -> Void) {
        guard let currentUser = authService.getCurrentUser() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])))
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        firestoreService.joinFamily(inviteCode: inviteCode, userId: currentUser.uid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let family):
                    self?.currentFamily = family
                    self?.setupFamilyListener(familyId: family.id?.uuidString ?? "")
                    completion(.success(family))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchFamilyData(for user: User) {
        // This would typically fetch the family data based on the user's familyId
        // For now, we'll just check if the user is part of any family
        let db = Firestore.firestore()
        db.collection("families").whereField("members", arrayContains: authService.getCurrentUser()?.uid ?? "").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching family data: \(error)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                // User is not part of any family
                return
            }
            
            let data = document.data()
            let family = Family(
                name: data["name"] as? String ?? "",
                members: [],
                house: House(rooms: [], furniture: [], theme: .modern),
                virtualPet: nil,
                inviteCode: data["inviteCode"] as? String ?? ""
            )
            
            DispatchQueue.main.async {
                self?.currentFamily = family
                self?.setupFamilyListener(familyId: document.documentID)
            }
        }
    }
    
    // MARK: - Real-time Listeners
    private func setupFamilyListener(familyId: String) {
        let db = Firestore.firestore()
        
        familyListener = db.collection("families").document(familyId).addSnapshotListener { [weak self] document, error in
            if let error = error {
                print("Error listening to family updates: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                return
            }
            
            let data = document.data() ?? [:]
            let family = Family(
                name: data["name"] as? String ?? "",
                members: [],
                house: House(rooms: [], furniture: [], theme: .modern),
                virtualPet: nil,
                inviteCode: data["inviteCode"] as? String ?? ""
            )
            
            DispatchQueue.main.async {
                self?.currentFamily = family
            }
        }
    }
    
    private func removeListeners() {
        familyListener?.remove()
        familyListener = nil
        messagesListener?.remove()
        messagesListener = nil
    }
    
    // MARK: - Messages
    func sendMessage(content: String, type: MessageType = .text, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = authService.getCurrentUser(),
              let familyId = currentFamily?.id?.uuidString else {
            completion(.failure(NSError(domain: "FirebaseManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No family selected"])))
            return
        }
        
        let message = Message(
            id: UUID(),
            senderId: currentUser.uid,
            content: content,
            type: type,
            timestamp: Date(),
            isRead: false
        )
        
        firestoreService.sendMessage(familyId: familyId, message: message) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
}
