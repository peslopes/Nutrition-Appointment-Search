import Combine
import Foundation
@testable import Nutrition_Appointment_Search

class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var getProfessionalsResponse: ProfessionalsResponse?
    var getProfessionalProfileResponse: Professional?
    
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        
        switch endpoint {
            
        case .getProfessionals:
            let mockResponse = getProfessionalsResponse ?? ProfessionalsResponse(count: 0, offset: 0, limit: 0, professionals: [])
            return Just(mockResponse as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .getProfessionalProfile:
            let mockResponse = getProfessionalProfileResponse ?? Professional(id: 0, name: "", rating: 0, rating_count: 0, languages: [], expertise: [], profile_picture_url: nil, about_me: nil)
            return Just(mockResponse as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        
    }
}
