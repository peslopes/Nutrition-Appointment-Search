import Combine
import Foundation

class ProfessionalProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var professional: Professional?
    
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let professionalId: Int
    
    init(apiService: APIServiceProtocol = APIService(), professionalId: Int) {
        self.professionalId = professionalId
        self.apiService = apiService
    }
    
    func fetchProfessional() {
        isLoading = true
        apiService.fetch(.getProfessionalProfile(id: professionalId))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handleFailure(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.handleSuccess(response)
            })
            .store(in: &cancellables)
    }
}

extension ProfessionalProfileViewModel {
    private func handleFailure(_ error: Error) {
        isLoading = false
        errorMessage = "Failed to load professional profile: \(error.localizedDescription)"
    }
    
    private func handleSuccess(_ professional: Professional) {
        isLoading = false
        self.professional = professional
    }
}
