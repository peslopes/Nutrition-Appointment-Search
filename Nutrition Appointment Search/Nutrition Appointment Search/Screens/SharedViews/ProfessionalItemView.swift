import SwiftUI

struct ProfessionalItemView: View {
    @State var name: String = ""
    @State var imageURL: URL? = nil
    @State var rating: Double = 0
    @State var languages: [String] = []
    @State var expertises: [String] = []
    @State var ratingCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: imageURL) { result in
                    (result.image ?? Image(systemName: LayoutConstants.fallbackImageSystemName))
                        .resizable()
                        .clipShape(.rect(cornerRadius: LayoutConstants.cornerRadius))
                        .scaledToFit()
                }
                .frame(width: LayoutConstants.imageWidth)
                
                VStack(alignment: .leading) {
                    Text(name)
                    
                    HStack {
                        RatingView(rating: rating, maxRating: LayoutConstants.maxRatings)
                            .frame(height: LayoutConstants.ratingsHeight)
                        Text("(\(ratingCount))")
                    }
                    
                    HStack {
                        Image(systemName: LayoutConstants.languagesIconSystemName)
                        Text(languages.joined(separator: LayoutConstants.languagesTextSeparator))
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(alignment: .leading) {
                ForEach(expertises, id: \.self) { expertise in
                    Text(expertise)
                        .padding(LayoutConstants.expertisePadding)
                        .background {
                            RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                                .fill(LayoutConstants.expertiseBackgroundColor)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .overlay {
            RoundedRectangle(cornerRadius: LayoutConstants.cornerRadius)
                .stroke(LayoutConstants.strokeColor, lineWidth: LayoutConstants.strokeLineWidth)
        }
    }
}

extension ProfessionalItemView {
    enum LayoutConstants {
        static let imageWidth: CGFloat = 100
        static let fallbackImageSystemName = "person"
        static let cornerRadius: CGFloat = 8
        
        static let maxRatings: Int = 5
        static let ratingsHeight: CGFloat = 25
        
        static let languagesIconSystemName = "globe"
        static let languagesTextSeparator = ", "
        
        static let expertisePadding: CGFloat = 4
        static let expertiseBackgroundColor = Color.gray.opacity(0.5)
        
        static let strokeColor = Color.gray
        static let strokeLineWidth: CGFloat = 4
    }
}

#Preview {
    ProfessionalItemView(
        name: "Patricia Fernandes",
        imageURL: URL(string: "https://thispersondoesnotexist.com/"),
        rating: 3.3,
        languages: ["English", "Portuguese"],
        expertises: ["Pediatrics", "Weight Gain"]
    )
}
