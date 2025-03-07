import SwiftUI

struct ProfessionalItemView: View {
    @State var name: String = ""
    @State var imageURL: URL? = nil
    @State var rating: Double = 0
    @State var languages: [String] = []
    @State var expertises: [String] = []
    
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
                    Text(expertise)
                        .padding(4)
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
