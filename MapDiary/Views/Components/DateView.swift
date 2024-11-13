import SwiftUI

struct DateView: View {
    let date: Date
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.caption)
            Text(date.formatted(date: .numeric, time: .omitted))
                .font(.caption)
        }
    }
}
