import SwiftUI

struct LocationView: View {
    let location: DiaryEntry.Location
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.fill")
                .font(.caption)
            Text(location.city)
                .font(.caption)
        }
    }
}
