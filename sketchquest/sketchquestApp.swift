import SwiftUI
import SwiftData

@main
struct SketchQuestApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: DrawingRecord.self)
    }
}
