import SwiftUI
import UIKit

struct ResultView: View {
    let result: GuessResult
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(uiImage: result.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260, maxHeight: 260)
                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 22)

                Text(result.prediction.label.capitalized)
                    .font(.largeTitle.bold())

                Text("Model confidence: \(result.prediction.confidence, format: .percent.precision(.fractionLength(1)))")
                    .foregroundStyle(.secondary)

                if let expected = result.expected {
                    Text(result.succeeded ? "Great job! Correct sketch!" : "Not quite! You were asked to draw \(expected).")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("+\(result.points) points")
                        .font(.title2.bold())
                        .foregroundStyle(result.succeeded ? .green : .orange)
                } else {
                    Text("Free Draw: Explore what your model recognizes!")
                        .foregroundStyle(.secondary)
                }

                Text("Confidence is a model score, not proof that its answer is correct.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Done") { dismiss() }
                    .buttonStyle(QuestButtonStyle())
                    .padding(.top, 12)
            }
            .padding(24)
        }
        .presentationDetents([.large])
    }
}
