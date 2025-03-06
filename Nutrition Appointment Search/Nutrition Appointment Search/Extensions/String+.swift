import Foundation

extension String {
    func toURL() -> URL? {
        URL(string: self)
    }
}
