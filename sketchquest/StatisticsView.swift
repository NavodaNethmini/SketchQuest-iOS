import SwiftUI
import SwiftData
import Charts

struct DailyScore: Identifiable {
    let id: Int
    let day: Date
    let points: Int
}

struct StatisticsView: View {
    @Query private var records: [DrawingRecord]

    private var challenges: [DrawingRecord] {
        records.filter { $0.expectedLabel != nil }
    }

    private var wins: Int {
        challenges.filter { $0.earnedPoints > 0 }.count
    }

    private var weeklyScores: [DailyScore] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: offset - 6, to: today) ?? today
            let points = records
                .filter { calendar.isDate($0.createdAt, inSameDayAs: day) }
                .reduce(0) { $0 + $1.earnedPoints }
            return DailyScore(id: offset, day: day, points: points)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your drawing journey")
                    .font(.title2.bold())

                stat("Saved sketches", value: "\(records.count)", symbol: "scribble.variable")
                stat("Total points", value: "\(records.reduce(0) { $0 + $1.earnedPoints })", symbol: "star.fill")
                stat("Challenge wins", value: "\(wins) / \(challenges.count)", symbol: "checkmark.seal.fill")
                let rate = challenges.isEmpty ? 0 : Double(wins) / Double(challenges.count)
                stat("Challenge success rate", value: rate.formatted(.percent.precision(.fractionLength(0))), symbol: "chart.line.uptrend.xyaxis")

                Text("Points earned in the last 7 days")
                    .font(.headline)
                    .padding(.top, 8)

                Chart(weeklyScores) { item in
                    BarMark(x: .value("Day", item.day, unit: .day),
                            y: .value("Points", item.points))
                        .foregroundStyle(SketchTheme.blue.gradient)
                }
                .frame(height: 210)
                .chartYAxis { AxisMarks(position: .leading) }

                Text("Success rate is based on challenge results, not a formal measure of ML model accuracy.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Progress")
    }

    private func stat(_ name: String, value: String, symbol: String) -> some View {
        HStack {
            Label(name, systemImage: symbol)
            Spacer()
            Text(value).font(.headline).monospacedDigit()
        }
        .padding(17)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
