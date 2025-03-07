import Foundation
import SwiftData

final class CacheHandler: CacheHandlerProtocol {
    private let shortTermCache = NSCache<NSString, AnyObject>()
    private let maxCacheAge: TimeInterval = 10 * 60
    private let cacheActor: CacheActor
    
    static let shared: CacheHandler = {
        do {
            let schema = Schema([CachedResponse.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            let cacheActor = CacheActor(modelContainer: container)
            return CacheHandler(cacheActor: cacheActor)
        } catch {
            fatalError("Fail to setup SwiftData: \(error)")
        }
    }()
    
    private init(cacheActor: CacheActor) {
        self.cacheActor = cacheActor
    }
    
    func saveResponse(_ response: Data, forUrl url: String) {
        let cacheKey = url as NSString
        shortTermCache.setObject(response as AnyObject, forKey: cacheKey)
        
        Task {
            await cacheActor.clearCachedResponse(forUrl: url)
            let cachedResponse = CachedResponse(url: url, data: response, timestamp: Date())
            await cacheActor.saveResponse(cachedResponse)
        }
    }
    
    func getResponse(forUrl url: String) -> Data? {
        let cacheKey = url as NSString
        
        if let cachedData = shortTermCache.object(forKey: cacheKey) as? Data {
            return cachedData
        }
        
        var cachedData: Data?
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            if let cacheItem = await cacheActor.fetchResponse(forUrl: url) {
                if cacheItem.timestamp.addingTimeInterval(maxCacheAge) < Date() {
                    await cacheActor.clearCachedResponse(forUrl: url)
                } else {
                    shortTermCache.setObject(cacheItem.data as AnyObject, forKey: cacheKey)
                    cachedData = cacheItem.data
                }
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return cachedData
    }
    
    func clearExpiredCache() {
        let cutoffDate = Date().addingTimeInterval(-maxCacheAge)
        
        Task {
            await cacheActor.clearExpiredResponses(cutoffDate: cutoffDate)
        }
    }
}
