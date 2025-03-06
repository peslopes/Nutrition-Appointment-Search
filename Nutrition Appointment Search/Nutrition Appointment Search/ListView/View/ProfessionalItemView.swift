import SwiftUI

struct ProfessionalItemView: View {
    let name: String
    let imageURL: URL?
    let rating: Double
    let languages: [String]
    let expertises: [String]
    
    init(name: String = "", imageURL: URL? = nil, rating: Double = 0.0, languages: [String] = [], expertises: [String] = []) {
        self.name = name
        self.imageURL = imageURL
        self.rating = rating
        self.languages = languages
        self.expertises = expertises
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: imageURL) { result in
                    (result.image ?? Image(systemName: "person"))
                        .resizable()
                        .clipShape(.rect(cornerRadius: 8))
                        .scaledToFit()
                }
                .frame(width: 100)
                
                VStack(alignment: .leading) {
                    Text(name)
                    RatingView(rating: rating, maxRating: 5)
                        .frame(height: 25)
                    HStack {
                        Image(systemName: "globe")
                        Text(languages.joined(separator: ", "))
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(alignment: .leading) {
                ForEach(expertises, id: \.self) { expertise in
                    Text(" \(expertise) ")
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.5))
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 4)
        }
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
