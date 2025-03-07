import Foundation

enum Endpoint {
    static let baseURL = "https://nutrisearch.vercel.app/professionals"
    
    case getProfessionals(limit: Int = 4, offset: Int = 0, sortBy: String)
    
    var url: URL? {
        switch self {
        case .getProfessionals(limit: let limit, offset: let offset, sortBy: let sortBy):
            let urlString = "\(Endpoint.baseURL)/search?limit=\(limit)&offset=\(offset)&sortBy=\(sortBy)"
            return URL(string: urlString)
        }
    }
}
