import Combine
import Foundation
@testable import Nutrition_Appointment_Search

class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var response: ProfessionalsResponse?
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        
        let mockResponse = response ?? ProfessionalsResponse(count: 0, offset: 0, limit: 0, professionals: [])
        return Just(mockResponse as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
