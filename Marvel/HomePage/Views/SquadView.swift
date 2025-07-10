import SwiftUI
import Kingfisher

struct SquadView: View {
    var image: String
    var name: String
    var size: CharacterImageSize = .medium
    
    var body: some View {
        VStack {
            KFImage(URL(string: image + size.rawValue))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: .xLarge, height: .xLarge)

            VStack {
                Text(name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(.white)
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("SquadCell_\(name)")

                Spacer()
            }
            .frame(height: .large)
        }
        .frame(maxWidth: .xLarge)
    }
}
