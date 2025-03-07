import SwiftUI

struct CollapsibleView<Content: View>: View {
    @State var content: () -> Content
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isExpanded {
                content()
                .padding()
                .transition(.opacity.combined(with: .slide))
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding()
    }
}

struct CollapsibleView_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleView {
            Text("This is an example of a big text with a lot of description. It is just an example. It is just an example. It is just an example.")
        }
    }
}
