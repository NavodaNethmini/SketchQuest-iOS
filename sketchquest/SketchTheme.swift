import SwiftUI

enum SketchTheme {
    static let blue = Color(red: 0.27, green: 0.35, blue: 0.94)
    static let purple = Color(red: 0.61, green: 0.32, blue: 0.93)
}

// Reusable custom button style: satisfies the assignment's custom SwiftUI requirement.
struct QuestButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [SketchTheme.blue, SketchTheme.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 17))
            .opacity(isEnabled ? 1 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
