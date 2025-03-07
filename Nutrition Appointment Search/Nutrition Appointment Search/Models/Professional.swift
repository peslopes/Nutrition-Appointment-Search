struct Professional: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let rating: Double
    let rating_count: Int
    let languages: [String]
    let expertise: [String]
    let profile_picture_url: String?
    let about_me: String?
}
