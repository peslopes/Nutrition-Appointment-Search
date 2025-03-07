struct ProfessionalsResponse: Decodable {
    let count: Int
    let offset: Int
    let limit: Int
    let professionals: [Professional]
}
