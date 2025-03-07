import Foundation

protocol CacheHandlerProtocol {
    func saveResponse(_ response: Data, forUrl url: String)
    func getResponse(forUrl url: String) -> Data?
}
