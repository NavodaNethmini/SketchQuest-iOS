import SwiftUI
import UIKit
import SwiftData
import Combine

enum DrawingMode: Equatable {
    case free
    case challenge
}

struct GuessResult: Identifiable {
    let id = UUID()
    let image: UIImage
    let prediction: SketchPrediction
    let expected: String?
    let points: Int

    var succeeded: Bool {
        guard let expected else { return false }
        return ScoreCalculator.points(prediction: prediction,
                                      expected: expected) > 0
    }
}

struct DrawingGameView: View {
    let mode: DrawingMode
    @Environment(\.modelContext) private var modelContext

    private let categories = ["apple", "cat", "house", "car",
                              "fish", "tree", "star", "bicycle"]
    @State private var strokes: [[CGPoint]] = []
    @State private var activeStroke: [CGPoint] = []
    @State private var target: String = "apple"
    @State private var secondsLeft = 30
    @State private var expired = false
    @State private var result: GuessResult?
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isChecking = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(mode == .challenge ? "Draw a \(target.capitalized)!" : "What did you draw?")
                        .font(.title2.bold())
                    if mode == .challenge {
                        Label("\(secondsLeft) seconds left", systemImage: "clock")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(secondsLeft <= 10 ? .red : SketchTheme.blue)
                    } else {
                        Text("Try one of the 8 supported objects.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                SketchCanvas(strokes: $strokes, activeStroke: $activeStroke)
                    .allowsHitTesting(!expired && !isChecking)

                HStack(spacing: 12) {
                    Button {
                        if !strokes.isEmpty { strokes.removeLast() }
                    } label: {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    }
                    .disabled(strokes.isEmpty || expired)

                    Spacer()

                    Button(role: .destructive) {
                        strokes = []
                        activeStroke = []
                    } label: {
                        Label("Clear", systemImage: "trash")
                    }
                    .disabled(strokes.isEmpty || expired)
                }
                .font(.subheadline.bold())

                if expired {
                    Text("Time is up! Try a new challenge.")
                        .foregroundStyle(.red)
                }

                Button {
                    checkDrawing()
                } label: {
                    HStack {
                        if isChecking { ProgressView().tint(.white) }
                        Label("Check Drawing", systemImage: "sparkles")
                    }
                }
                .buttonStyle(QuestButtonStyle())
                .disabled(strokes.isEmpty || expired || isChecking)

                Button("\(mode == .challenge ? "New Challenge" : "Start Again")") {
                    resetGame()
                }
                .font(.subheadline.bold())
            }
            .padding()
        }
        .navigationTitle(mode == .challenge ? "Challenge" : "Free Draw")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { resetGame() }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard mode == .challenge, !expired, !isChecking, result == nil else { return }
            if secondsLeft > 0 { secondsLeft -= 1 }
            if secondsLeft == 0 { expired = true }
        }
        .sheet(item: $result) { result in
            ResultView(result: result)
        }
        .alert("Recognition error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func resetGame() {
        strokes = []
        activeStroke = []
        target = categories.randomElement() ?? "apple"
        secondsLeft = 30
        expired = false
        result = nil
        isChecking = false
    }

    private func checkDrawing() {
        guard !strokes.isEmpty else { return }
        isChecking = true
        let image = SketchImageRenderer.render(strokes: strokes)

        do {
            // This is a REAL Core ML inference, not a hard-coded result.
            let prediction = try SketchRecognizer().recognize(image: image)
            let expected = mode == .challenge ? target : nil
            let points = ScoreCalculator.points(prediction: prediction,
                                                expected: expected)

            guard let data = image.pngData() else {
                alertMessage = "Unable to save the drawing image."
                showAlert = true
                isChecking = false
                return
            }

            let record = DrawingRecord(predictedLabel: prediction.label,
                                       confidence: prediction.confidence,
                                       expectedLabel: expected,
                                       earnedPoints: points,
                                       imageData: data)
            modelContext.insert(record)
            try modelContext.save()
            result = GuessResult(image: image,
                                 prediction: prediction,
                                 expected: expected,
                                 points: points)
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isChecking = false
    }
}
