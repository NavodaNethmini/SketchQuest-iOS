import Foundation
import SwiftData

@Model
final class DrawingRecord {
    var createdAt: Date
    var predictedLabel: String
    var confidence: Double
    var expectedLabel: String?
    var earnedPoints: Int
    @Attribute(.externalStorage) var imageData: Data

    init(predictedLabel: String,
         confidence: Double,
         expectedLabel: String?,
         earnedPoints: Int,
         imageData: Data) {
        self.createdAt = .now
        self.predictedLabel = predictedLabel
        self.confidence = confidence
        self.expectedLabel = expectedLabel
        self.earnedPoints = earnedPoints
        self.imageData = imageData
    }
}
