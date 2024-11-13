import SwiftUI

struct DiaryDetailView: View {
    let entry: DiaryEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 封面图区域
                GeometryReader { geometry in
                    let minHeight: CGFloat = 500
                    let scrollOffset = geometry.frame(in: .global).minY
                    
                    ZStack(alignment: .bottomLeading) {
                        // 图片
                        Image(entry.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: geometry.size.width,
                                height: minHeight + max(0, scrollOffset)
                            )
                            .offset(y: -scrollOffset * 0.5)
                        
                        // 标题信息
                        VStack(alignment: .leading, spacing: 8) {
                            Text(entry.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("\(entry.season) \(entry.year)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("\(entry.duration) days")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(24)
                        .padding(.bottom, 32)
                    }
                    .frame(height: max(minHeight + scrollOffset, minHeight))
                    .clipShape(
                        RoundedShape(
                            corners: [.bottomLeft],
                            radius: 60
                        )
                    )
                }
                .frame(height: 500)
                
                // 日记内容
                VStack(alignment: .leading, spacing: 16) {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Text(entry.content)
                        .lineSpacing(8)
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(.leading)
        }
        .navigationBarHidden(true)
    }
}

// 自定义圆角形状
struct RoundedShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


