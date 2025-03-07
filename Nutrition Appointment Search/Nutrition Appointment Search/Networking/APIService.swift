import Foundation
import Combine

class APIService: APIServiceProtocol {
    private let cacheHandler: CacheHandlerProtocol
    
    init(cacheHandler: CacheHandlerProtocol = CacheHandler.shared) {
        self.cacheHandler = cacheHandler
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, any Error> {
        if let cachedData = getCachedResponse(for: endpoint) {
            return Just(cachedData)
                .tryMap { data in
                    try JSONDecoder().decode(T.self, from: data)
                }
                .catch { error -> AnyPublisher<T, Error> in
                    print("Fail to decode cached data: \(error)")
                    return self.fetchFromAPI(endpoint)
                }
                .eraseToAnyPublisher()
        }
        
        return fetchFromAPI(endpoint)
    }
    
    private func fetchFromAPI<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .handleEvents(receiveOutput: { [weak self] data in
                self?.saveResponse(data, for: endpoint)
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func getCachedResponse(for endpoint: Endpoint) -> Data? {
        guard let urlString = endpoint.url?.absoluteString else { return nil }
        if let cachedData = cacheHandler.getResponse(forUrl: urlString) {
            return cachedData
        }
        return nil
    }
    
    private func saveResponse(_ data: Data, for endpoint: Endpoint) {
        guard let urlString = endpoint.url?.absoluteString else { return }
        cacheHandler.saveResponse(data, forUrl: urlString)
    }
}
