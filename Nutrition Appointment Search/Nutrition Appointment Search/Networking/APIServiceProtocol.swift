import Foundation
import Combine

protocol APIServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}
