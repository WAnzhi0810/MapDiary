import SwiftUI

struct TripListView: View {
    let entries: [DiaryEntry]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(entries) { entry in
                    NavigationLink(destination: DiaryDetailView(entry: entry)) {
                        DiaryCard(entry: entry)
                    }
                }
            }
            .padding()
        }
    }
}
