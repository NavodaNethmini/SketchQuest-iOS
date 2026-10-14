import SwiftUI

// Coordinates are stored as fractions (0...1), so the drawing scales to device size.
struct SketchCanvas: View {
    @Binding var strokes: [[CGPoint]]
    @Binding var activeStroke: [CGPoint]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white

                Canvas { context, size in
                    for stroke in strokes + [activeStroke] where !stroke.isEmpty {
                        let points = stroke.map {
                            CGPoint(x: $0.x * size.width, y: $0.y * size.height)
                        }
                        if points.count == 1 {
                            let dot = CGRect(x: points[0].x - 3,
                                             y: points[0].y - 3,
                                             width: 6, height: 6)
                            context.fill(Path(ellipseIn: dot), with: .color(.black))
                        } else {
                            var path = Path()
                            path.addLines(points)
                            context.stroke(
                                path,
                                with: .color(.black),
                                style: StrokeStyle(lineWidth: 5,
                                                   lineCap: .round,
                                                   lineJoin: .round)
                            )
                        }
                    }
                }

                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let width = max(geometry.size.width, 1)
                                let height = max(geometry.size.height, 1)
                                let normalized = CGPoint(
                                    x: min(max(value.location.x / width, 0), 1),
                                    y: min(max(value.location.y / height, 0), 1)
                                )
                                activeStroke.append(normalized)
                            }
                            .onEnded { _ in
                                if !activeStroke.isEmpty {
                                    strokes.append(activeStroke)
                                }
                                activeStroke = []
                            }
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18)
                .strokeBorder(SketchTheme.blue.opacity(0.25), lineWidth: 2))
        }
        .frame(height: 335)
        .accessibilityLabel("Drawing canvas. Drag your finger to sketch.")
    }
}
