import Combine
import Foundation

class ListViewModel: ObservableObject {
    @Published var professionals = Array<Professional>()
    @Published var isLoading = false
    @Published var isPaginating = false
    @Published var errorMessage: String?
    @Published var selectedSortBy: SortOption = Constants.defaultSortOption
    
    let limit = Constants.defaultLimit
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    private var currentOffset = 0
    private var totalProfessionalsCount = 0
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        setupBindings()
    }
    
    func paginateIfNeeded(for professional: Professional) {
        guard
            professional == professionals.last,
            currentOffset < totalProfessionalsCount,
            !isPaginating
        else { return }
            
        isPaginating = true
        fetchProfessionals(shouldPresentError: false, sortBy: selectedSortBy)
    }
    
    func loadProfessionals(sortBy: SortOption? = nil) {
        guard
            !isLoading,
            professionals.isEmpty
        else { return }
        
        isLoading = true
        errorMessage = nil
        
        fetchProfessionals(sortBy: sortBy ?? selectedSortBy)
    }
}

extension ListViewModel {
    private func fetchProfessionals(shouldPresentError: Bool = true, sortBy: SortOption) {
        apiService.fetch(.getProfessionals(limit: limit, offset: currentOffset, sortBy: sortBy.rawValue))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handleFailure(error, shouldPresentError: shouldPresentError)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.handleSuccess(response)
            })
            .store(in: &cancellables)
    }
    
    private func handleSuccess(_ response: ProfessionalsResponse) {
        if !response.professionals.isEmpty {
            if currentOffset == 0 {
                professionals = response.professionals
            } else {
                professionals.append(contentsOf: response.professionals)
            }

            currentOffset = professionals.count
            totalProfessionalsCount = response.count
        } else {
            errorMessage = "No professionals found."
        }
        isLoading = false
        isPaginating = false
    }
    
    private func handleFailure(_ error: Error, shouldPresentError: Bool = true) {
        if shouldPresentError {
            errorMessage = "Failed to load professionals: \(error.localizedDescription)"
        }
        
        isLoading = false
        isPaginating = false
    }
    
    private func reloadData(sortBy: SortOption) {
        guard !isLoading, !isPaginating else { return }
        professionals.removeAll()
        currentOffset = 0
        totalProfessionalsCount = 0
        loadProfessionals(sortBy: sortBy)
    }
    
    private func setupBindings() {
        $selectedSortBy
            .sink { [weak self] newValue in
                self?.reloadData(sortBy: newValue)
            }
            .store(in: &cancellables)
    }
}

extension ListViewModel {
    enum SortOption: String {
        case mostPopular = "most_popular"
        case rating = "rating"
        case bestMatch = "best_match"
    }
}

extension ListViewModel {
    enum Constants {
        static let defaultSortOption: SortOption = .bestMatch
        static let defaultLimit = 6
    }
}
