import SwiftData
import Foundation

@Model
final class CachedResponse {
    var url: String
    var data: Data
    var timestamp: Date
    
    init(url: String, data: Data, timestamp: Date) {
        self.url = url
        self.data = data
        self.timestamp = timestamp
    }
}
