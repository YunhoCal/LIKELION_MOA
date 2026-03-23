import Foundation

// Main interest categories
struct InterestCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let subcategories: [String]

    static let allCategories: [InterestCategory] = [
        InterestCategory(
            id: "sports_exercise",
            name: "Sports & Exercise",
            emoji: "⚽️",
            subcategories: ["Badminton", "Running", "Gym/CrossFit", "Swimming", "Yoga", "Hiking", "Cycling", "Martial Arts", "Rock Climbing"]
        ),
        InterestCategory(
            id: "reading_writing",
            name: "Reading & Writing",
            emoji: "📚",
            subcategories: ["Book Club", "Poetry", "Creative Writing", "Journalism", "Literature", "Blogging", "Storytelling"]
        ),
        InterestCategory(
            id: "language_exchange",
            name: "Language Exchange",
            emoji: "🗣️",
            subcategories: ["English", "Korean", "Japanese", "Chinese", "Spanish", "French", "German", "Arabic", "Portuguese"]
        ),
        InterestCategory(
            id: "festivals_culture",
            name: "Festivals & Culture",
            emoji: "🎭",
            subcategories: ["Museums", "Art Galleries", "Cultural Events", "Food Festivals", "Music Festivals", "Theater", "Opera", "Traditional Arts"]
        ),
        InterestCategory(
            id: "music_instruments",
            name: "Music & Instruments",
            emoji: "🎵",
            subcategories: ["Singing", "Guitar", "Piano", "Drums", "Violin", "DJing", "Music Production", "Karaoke", "Band Practice"]
        ),
        InterestCategory(
            id: "arts_crafts",
            name: "Arts & Crafts",
            emoji: "🎨",
            subcategories: ["Candle Making", "Pottery", "Painting", "Drawing", "Knitting", "Crocheting", "Woodworking", "Origami", "Jewelry Making"]
        ),
        InterestCategory(
            id: "dance",
            name: "Dance",
            emoji: "💃",
            subcategories: ["Ballet", "Hip Hop", "Contemporary", "K-pop", "Salsa", "Ballroom", "Jazz", "Breakdancing", "Line Dancing"]
        ),
        InterestCategory(
            id: "volunteering",
            name: "Volunteering",
            emoji: "🤝",
            subcategories: ["Community Service", "Environmental", "Animal Welfare", "Teaching", "Elderly Care", "Food Banks", "Charity Events"]
        ),
        InterestCategory(
            id: "social_events",
            name: "Social Events",
            emoji: "🎉",
            subcategories: ["Networking", "Parties", "Meetups", "Happy Hours", "Coffee Chats", "Dinner Clubs", "Game Nights"]
        ),
        InterestCategory(
            id: "cars_bikes",
            name: "Cars & Bikes",
            emoji: "🏍️",
            subcategories: ["Car Meets", "Motorcycles", "Road Trips", "Racing", "Auto Repair", "Bike Maintenance", "Classic Cars"]
        ),
        InterestCategory(
            id: "photo_video",
            name: "Photography & Video",
            emoji: "📸",
            subcategories: ["Photography", "Videography", "Filmmaking", "Editing", "Drone Photography", "Portrait", "Street Photography"]
        ),
        InterestCategory(
            id: "watching_sports",
            name: "Watching Sports",
            emoji: "🏟️",
            subcategories: ["Baseball", "Basketball", "Soccer", "Football", "Hockey", "Tennis", "Golf", "MMA", "Boxing"]
        ),
        InterestCategory(
            id: "gaming_esports",
            name: "Gaming & E-sports",
            emoji: "🎮",
            subcategories: ["PC Gaming", "Console Gaming", "Mobile Gaming", "Board Games", "E-sports", "Card Games", "VR Gaming"]
        ),
        InterestCategory(
            id: "cooking_food",
            name: "Cooking & Food",
            emoji: "🍳",
            subcategories: ["Cooking Classes", "Baking", "Wine Tasting", "Food Tours", "BBQ", "International Cuisine", "Desserts", "Meal Prep"]
        ),
        InterestCategory(
            id: "pets_animals",
            name: "Pets & Animals",
            emoji: "🐕",
            subcategories: ["Dog Walking", "Cat Cafes", "Pet Care", "Animal Shelters", "Bird Watching", "Aquariums", "Wildlife"]
        ),
        InterestCategory(
            id: "self_development",
            name: "Self Development",
            emoji: "🌱",
            subcategories: ["Meditation", "Personal Growth", "Productivity", "Public Speaking", "Career Development", "Mindfulness", "Life Coaching"]
        )
    ]

    static func getCategory(byId id: String) -> InterestCategory? {
        return allCategories.first { $0.id == id }
    }
}

// User's selected interests
struct UserInterests: Codable {
    var categories: [String] // Category IDs
    var subcategories: [String] // Subcategory names

    init(categories: [String] = [], subcategories: [String] = []) {
        self.categories = categories
        self.subcategories = subcategories
    }
}
