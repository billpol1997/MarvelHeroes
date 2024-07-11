import SwiftUI

struct SquadButton: View {
    @Binding var isInSquad: Bool
    let buttonAction: () -> ()

    var body: some View {
        Button(action: {
            buttonAction()
        }) {
            Text(
                isInSquad
                    ? TextContent.squadButtonFireText
                    : TextContent.squadButtonRecruitText
            )
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(height: .large)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(isInSquad ? .clear : .redLight)
        .cornerRadius(.small)
        .shadow(color: .redHighlight, radius: .medium)
        .overlay(
            RoundedRectangle(cornerRadius: .small)
                .stroke(
                    isInSquad ? Color.redLight : .redDark,
                    style: StrokeStyle(lineWidth: .xSmall)
                )
        )
    }
}
