import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var records: [DrawingRecord]

    private var totalPoints: Int {
        records.reduce(0) { $0 + $1.earnedPoints }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Draw. Guess. Learn.")
                        .font(.title.bold())
                    Text("Make something amazing and discover what AI sees.")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Label("\(totalPoints) points", systemImage: "star.fill")
                        .foregroundStyle(.orange)
                    Spacer()
                    Label("\(records.count) sketches", systemImage: "scribble.variable")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline.bold())
                .padding(18)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))

                NavigationLink {
                    DrawingGameView(mode: .challenge)
                } label: {
                    featureCard(title: "Drawing Challenge",
                                description: "Beat the 30-second clock!",
                                icon: "timer", color: SketchTheme.blue)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    DrawingGameView(mode: .free)
                } label: {
                    featureCard(title: "Free Draw",
                                description: "Sketch anything from our 8 categories.",
                                icon: "pencil.tip.crop.circle", color: SketchTheme.purple)
                }
                .buttonStyle(.plain)

                Text("Objects: apple, cat, house, car, fish, tree, star, bicycle.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("SketchQuest")
    }

    private func featureCard(title: String, description: String,
                             icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 31, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 60, height: 64)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.headline)
                Text(description).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer(minLength: 2)
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(15)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 21))
    }
}
