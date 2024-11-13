import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    @Binding var viewMode: ViewMode
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.primary)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Spacer()
            
            HStack(spacing: 0) {
                viewModeButton(mode: .list, icon: "square.stack")
                viewModeButton(mode: .map, icon: "map")
            }
            .background(
                Capsule()
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: 32)
            )
            .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(.clear)
        )
    }
    
    private func viewModeButton(mode: ViewMode, icon: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                viewMode = mode
            }
        } label: {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(viewMode == mode ? .primary : .secondary)
                .frame(width: 44, height: 32)
                .background(
                    Capsule()
                        .fill(viewMode == mode ? .white : .clear)
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                )
        }
    }
}
