import SwiftUI

struct DiaryCard: View {
    let entry: DiaryEntry
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(entry.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    Label(
                        entry.date.formatted(date: .abbreviated, time: .omitted),
                        systemImage: "calendar"
                    )
                    
                    Label(
                        entry.location.city,
                        systemImage: "location.fill"
                    )
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
}
