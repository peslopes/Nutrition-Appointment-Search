import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel()

    var body: some View {
        VStack {
            Picker("Sort by", selection: $viewModel.selectedSortBy) {
                Text("Most Popular").tag(ListViewModel.SortOption.mostPopular)
                Text("Rating").tag(ListViewModel.SortOption.rating)
                Text("Best Match").tag(ListViewModel.SortOption.bestMatch)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .disabled(viewModel.isLoading || viewModel.isPaginating)
            
            if viewModel.isLoading {
                List {
                    ForEach(0..<viewModel.limit, id: \ .self) { _ in
                        loadingPlaceholder
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage: errorMessage)
            } else {
                professionalsList
            }
        }
        .onAppear {
            viewModel.loadProfessionals()
        }
    }
    
    private var loadingPlaceholder: some View {
        ProfessionalItemView()
            .redacted(reason: .placeholder)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack {
            Text(errorMessage)
            Button("Retry") {
                viewModel.loadProfessionals()
            }
        }
    }
    
    private var professionalsList: some View {
        List(viewModel.professionals) { professional in
            ProfessionalItemView(
                name: professional.name,
                imageURL: professional.profile_picture_url?.toURL(),
                rating: professional.rating,
                languages: professional.languages,
                expertises: professional.expertise
            )
            .onAppear {
                viewModel.paginateIfNeeded(for: professional)
            }
            
            if viewModel.isPaginating, professional == viewModel.professionals.last {
                loadingPlaceholder
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ListView()
}
