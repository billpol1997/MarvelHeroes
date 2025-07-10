import SwiftUI
import Kingfisher

enum CharacterImageSize: String {
    case small = "/standard_amazing.jpg"
    case medium = "/standard_xlarge.jpg"
    case big = "/standard_fantastic.jpg"
}

struct HeroView: View {

    var image: String
    var name: String
    var size: CharacterImageSize = .small
    
    var body: some View {
        HStack {
            KFImage(URL(string: image + size.rawValue))
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: .large, height: .large)
                .padding(.vertical, .medium)
                .padding(.leading, .medium)
                .padding(.trailing, 8)

            Text(name)
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("CharacterCell_\(name)")

            Spacer()

            Image.chevronImage
                .padding(.horizontal, .medium)
                .foregroundColor(Color.greyLight)
        }
        .background(Color.greyMedium)
        .cornerRadius(8)
    }
}
