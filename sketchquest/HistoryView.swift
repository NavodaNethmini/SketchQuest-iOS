import SwiftUI
import UIKit
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DrawingRecord.createdAt, order: .reverse)
    private var records: [DrawingRecord]

    var body: some View {
        Group {
            if records.isEmpty {
                ContentUnavailableView("No drawings yet",
                                       systemImage: "scribble.variable",
                                       description: Text("Try a challenge or a free drawing first."))
            } else {
                List {
                    ForEach(records) { record in
                        HStack(spacing: 14) {
                            if let image = UIImage(data: record.imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(record.predictedLabel.capitalized).font(.headline)
                                Text(record.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Confidence: \(record.confidence, format: .percent.precision(.fractionLength(0)))  •  +\(record.earnedPoints) pts")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: delete)
                }
            }
        }
        .navigationTitle("Drawing History")
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
        do { try modelContext.save() }
        catch { print("Delete failed: \(error.localizedDescription)") }
    }
}
