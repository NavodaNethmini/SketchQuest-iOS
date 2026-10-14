import Foundation
import UIKit
import CoreML
import CoreVideo

struct SketchPrediction {
    let label: String
    let confidence: Double
}

enum SketchRecognitionError: LocalizedError {
    case invalidImage
    case pixelBufferFailed
    case emptyPrediction

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Could not read the drawing image."

        case .pixelBufferFailed:
            return "Could not prepare the image for Core ML."

        case .emptyPrediction:
            return "The model returned no prediction."
        }
    }
}

struct SketchRecognizer {

    func recognize(image: UIImage) throws -> SketchPrediction {

        // 1. Configure Core ML for simulator testing.
        let configuration = MLModelConfiguration()

        #if targetEnvironment(simulator)
        configuration.computeUnits = .cpuOnly
        #endif

        print("SketchQuest: Loading Core ML model")

        // 2. Load the trained model.
        let classifier = try SketchQuestCNN(
            configuration: configuration
        )

        // 3. Convert drawing to a 299 x 299 pixel buffer.
        let pixelBuffer = try makePixelBuffer(from: image)

        // 4. Prepare the model input.
        let input = try MLDictionaryFeatureProvider(
            dictionary: [
                "image": MLFeatureValue(
                    pixelBuffer: pixelBuffer
                )
            ]
        )

        print("SketchQuest: Starting direct Core ML prediction")

        // 5. Run inference without Vision.
        do {
            let output = try classifier.model.prediction(
                from: input
            )

            // 6. Read predicted object.
            guard let label = output.featureValue(
                for: "target"
            )?.stringValue else {
                throw SketchRecognitionError.emptyPrediction
            }

            // 7. Read probability dictionary.
            let probabilities = output.featureValue(
                for: "target_probs"
            )?.dictionaryValue

            let confidence = probabilities?[label]?.doubleValue ?? 0

            print("SketchQuest Prediction: \(label)")
            print("Confidence: \(confidence)")

            return SketchPrediction(
                label: label,
                confidence: confidence
            )

        } catch {
            let details = error as NSError

            print("SketchQuest ML ERROR")
            print("Domain: \(details.domain)")
            print("Code: \(details.code)")
            print("Details: \(details.userInfo)")

            throw error
        }
    }

    // Convert UIImage into Core ML compatible CVPixelBuffer.
    private func makePixelBuffer(
        from image: UIImage
    ) throws -> CVPixelBuffer {

        let width = 64
        let height = 64

        guard let cgImage = image.cgImage else {
            throw SketchRecognitionError.invalidImage
        }

        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]

        var optionalBuffer: CVPixelBuffer?

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attributes as CFDictionary,
            &optionalBuffer
        )

        guard status == kCVReturnSuccess,
              let pixelBuffer = optionalBuffer else {
            throw SketchRecognitionError.pixelBufferFailed
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])

        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapInfo =
            CGImageAlphaInfo.premultipliedFirst.rawValue |
            CGBitmapInfo.byteOrder32Little.rawValue

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw SketchRecognitionError.pixelBufferFailed
        }

        // White background.
        context.setFillColor(UIColor.white.cgColor)

        context.fill(
            CGRect(x: 0, y: 0, width: width, height: height)
        )

        // Match UIKit image orientation.
        //context.translateBy(x: 0, y: CGFloat(height))
        //context.scaleBy(x: 1, y: -1)

        context.interpolationQuality = .high

        // Draw sketch into the model input.
        context.draw(
            cgImage,
            in: CGRect(x: 0, y: 0, width: width, height: height)
        )
        
        return pixelBuffer
    }
}
