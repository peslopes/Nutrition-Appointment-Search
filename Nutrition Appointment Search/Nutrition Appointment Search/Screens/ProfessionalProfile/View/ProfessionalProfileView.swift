import SwiftUI

struct ProfessionalProfileView: View {
    @StateObject private var viewModel: ProfessionalProfileViewModel
    
    init(viewModel: ProfessionalProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    loadingPlaceholder
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    professionalsList
                }
            }
            .onAppear() {
                viewModel.fetchProfessional()
            }
        }
    }
    
    private var loadingPlaceholder: some View {
        ProfessionalItemView()
            .padding(.horizontal)
            .redacted(reason: .placeholder)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var professionalsList: some View {
        VStack(alignment: .leading) {
            ProfessionalItemView(
                name: viewModel.professional?.name ?? "No name",
                imageURL: viewModel.professional?.profile_picture_url?.toURL(),
                rating: viewModel.professional?.rating ?? 0,
                languages: viewModel.professional?.languages ?? [],
                expertises: viewModel.professional?.expertise ?? [],
                ratingCount: viewModel.professional?.rating_count ?? 0
            )
            .padding(.horizontal)
            
            if let aboutMe = viewModel.professional?.about_me {
                CollapsibleView {
                    Text(aboutMe)
                }
            }
        }
    }
}

#Preview {
    ProfessionalProfileView(viewModel: ProfessionalProfileViewModel(professionalId: 1))
}
