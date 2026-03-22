import Foundation
import Combine
import FirebaseFirestore

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()

    private let db = Firestore.firestore()
    @Published var activities: [Activity] = []

    private var activitiesListener: ListenerRegistration?

    // MARK: - Real-time Activity Listener

    func startListeningToActivities(category: String? = nil) {
        // Remove existing listener if any
        activitiesListener?.remove()

        var query: Query = db.collection("activities")

        if let category = category {
            query = query.whereField("category", isEqualTo: category)
        }

        query = query.order(by: "startDateTime", descending: false)

        activitiesListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error listening to activities: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.activities = documents.compactMap { doc -> Activity? in
                let data = doc.data()

                guard
                    let id = data["id"] as? String,
                    let title = data["title"] as? String,
                    let categoryStr = data["category"] as? String,
                    let category = Activity.ActivityCategory(rawValue: categoryStr),
                    let description = data["description"] as? String,
                    let hostUserId = data["hostUserId"] as? String,
                    let hostName = data["hostName"] as? String,
                    let hostUniversity = data["hostUniversity"] as? String,
                    let locationName = data["locationName"] as? String,
                    let locationLat = data["locationLat"] as? Double,
                    let locationLng = data["locationLng"] as? Double,
                    let startDateTimeTimestamp = data["startDateTime"] as? Timestamp,
                    let maxParticipants = data["maxParticipants"] as? Int,
                    let currentParticipants = data["currentParticipants"] as? Int,
                    let statusStr = data["status"] as? String,
                    let status = Activity.ActivityStatus(rawValue: statusStr),
                    let participants = data["participants"] as? [String]
                else {
                    return nil
                }

                let startDateTime = startDateTimeTimestamp.dateValue()
                let endDateTime = (data["endDateTime"] as? Timestamp)?.dateValue()
                let isInstant = data["isInstant"] as? Bool ?? false
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()

                return Activity(
                    id: id,
                    title: title,
                    category: category,
                    description: description,
                    hostUserId: hostUserId,
                    hostName: hostName,
                    hostUniversity: hostUniversity,
                    locationName: locationName,
                    locationLat: locationLat,
                    locationLng: locationLng,
                    startDateTime: startDateTime,
                    endDateTime: endDateTime,
                    isInstant: isInstant,
                    maxParticipants: maxParticipants,
                    currentParticipants: currentParticipants,
                    status: status,
                    participants: participants,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }

            print("✅ Firebase: Received \(self.activities.count) activities")
        }
    }

    func stopListeningToActivities() {
        activitiesListener?.remove()
        activitiesListener = nil
    }

    // MARK: - Real-time User Listener

    func listenToUser(userId: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        db.collection("users").document(userId).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data(),
                  let id = data["id"] as? String,
                  let email = data["email"] as? String,
                  let name = data["name"] as? String,
                  let university = data["university"] as? String
            else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])))
                return
            }

            let user = UserResponse(
                id: id,
                email: email,
                name: name,
                university: university,
                major: data["major"] as? String,
                graduation_year: data["graduation_year"] as? String,
                bio: data["bio"] as? String
            )

            completion(.success(user))
        }
    }

    deinit {
        stopListeningToActivities()
    }
}
