import Foundation
import SwiftData

@ModelActor
actor CacheActor {
    func saveResponse(_ item: CachedResponse) {
        modelContext.insert(item)
        try? modelContext.save()
    }
    
    func fetchResponse(forUrl url: String) -> CachedResponse? {
        let predicate = #Predicate<CachedResponse> { $0.url == url }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }
    
    func deleteResponse(_ item: CachedResponse) {
        modelContext.delete(item)
        try? modelContext.save()
    }
    
    func clearExpiredResponses(cutoffDate: Date) {
        let predicate = #Predicate<CachedResponse> { $0.timestamp < cutoffDate }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            let expiredResponses = try modelContext.fetch(descriptor)
            for response in expiredResponses {
                modelContext.delete(response)
            }
            try modelContext.save()
        } catch {
            print("Fail to clean cache: \(error)")
        }
    }
    
    func clearCachedResponse(forUrl url: String) {
        let predicate = #Predicate<CachedResponse> { $0.url == url }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            if let response = try modelContext.fetch(descriptor).first {
                modelContext.delete(response)
                try modelContext.save()
            }
        } catch {
            print("Fail to clean cache for key \(url): \(error)")
        }
    }
}
