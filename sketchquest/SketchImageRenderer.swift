import UIKit

// Converts drawing strokes into an image for AI recognition.
enum SketchImageRenderer {

    static func render(strokes: [[CGPoint]]) -> UIImage {

        let size: CGFloat = 299
        let allPoints = strokes.flatMap { $0 }

        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: size, height: size)
        )

        return renderer.image { context in

            let cg = context.cgContext

            // White background
            cg.setFillColor(UIColor.white.cgColor)
            cg.fill(
                CGRect(x: 0, y: 0, width: size, height: size)
            )

            guard !allPoints.isEmpty else { return }

            let minX = allPoints.map(\.x).min() ?? 0
            let maxX = allPoints.map(\.x).max() ?? 1
            let minY = allPoints.map(\.y).min() ?? 0
            let maxY = allPoints.map(\.y).max() ?? 1

            let width = max(maxX - minX, 0.05)
            let height = max(maxY - minY, 0.05)

            let scale = (size * 0.78) / max(width, height)

            let centerX = (minX + maxX) / 2
            let centerY = (minY + maxY) / 2

            func transformed(_ point: CGPoint) -> CGPoint {
                CGPoint(
                    x: size / 2 + (point.x - centerX) * scale,
                    y: size / 2 + (point.y - centerY) * scale
                )
            }

            // Black drawing strokes
            cg.setStrokeColor(UIColor.black.cgColor)
            cg.setFillColor(UIColor.black.cgColor)
            cg.setLineWidth(5.5)
            cg.setLineCap(.round)
            cg.setLineJoin(.round)

            for stroke in strokes where !stroke.isEmpty {

                let first = transformed(stroke[0])

                if stroke.count == 1 {

                    cg.fillEllipse(
                        in: CGRect(
                            x: first.x - 3,
                            y: first.y - 3,
                            width: 6,
                            height: 6
                        )
                    )

                } else {

                    cg.beginPath()
                    cg.move(to: first)

                    for point in stroke.dropFirst() {
                        cg.addLine(to: transformed(point))
                    }

                    cg.strokePath()
                }
            }
        }
    }
}
