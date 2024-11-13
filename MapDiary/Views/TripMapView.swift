import SwiftUI
import MapKit
import CoreLocation

// 在文件顶部添加通知名称的扩展
extension Notification.Name {
    static let regionDidChangeAnimated = Notification.Name("regionDidChangeAnimated")
}

struct TripMapView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0, longitude: 120.0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
    )
    
    @State private var debounceTimer: Timer?
    
    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: viewModel.mapAnnotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                DiaryAnnotationView(
                    image: annotation.representativeEntry.imageUrl,
                    title: annotation.displayTitle,
                    date: annotation.displayDate,
                    count: annotation.entries.count
                )
            }
        }
        .ignoresSafeArea()
        .onChange(of: region.center.latitude) { _ in
            NotificationCenter.default.post(name: .regionDidChangeAnimated, object: nil)
        }
        .onChange(of: region.center.longitude) { _ in
            NotificationCenter.default.post(name: .regionDidChangeAnimated, object: nil)
        }
        .onChange(of: region.span.latitudeDelta) { _ in
            NotificationCenter.default.post(name: .regionDidChangeAnimated, object: nil)
        }
        .onChange(of: region.span.longitudeDelta) { _ in
            NotificationCenter.default.post(name: .regionDidChangeAnimated, object: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: .regionDidChangeAnimated)) { _ in
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                viewModel.updateAnnotations(for: region)
            }
        }
    }
}

struct DiaryAnnotationView: View {
    let image: String
    let title: String
    let date: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                // 如果是聚合标注，显示数量
                if count > 1 {
                    Text("\(count)")
                        .font(.caption)
                        .padding(4)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .offset(x: 25, y: -25)
                }
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                Text(date)
                    .font(.caption2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .shadow(radius: 3)
    }
}
