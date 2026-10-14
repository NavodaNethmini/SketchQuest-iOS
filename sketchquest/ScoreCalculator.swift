import Foundation

// Isolated business rule: easy to unit test and change later.
enum ScoreCalculator {
    static func points(prediction: SketchPrediction, expected: String?) -> Int {
        guard let expected else { return 0 }
        let isCorrectClass = prediction.label.caseInsensitiveCompare(expected) == .orderedSame
        return isCorrectClass && prediction.confidence >= 0.50 ? 100 : 0
    }
}
