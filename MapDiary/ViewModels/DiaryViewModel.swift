import Foundation
import CoreLocation
import MapKit

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var mapAnnotations: [ClusteredAnnotation] = []
    @Published var zoomLevel: Double = 0
    
    // 聚合后的标注数据模型
    struct ClusteredAnnotation: Identifiable {
        let id: UUID = UUID()
        let coordinate: CLLocationCoordinate2D
        let entries: [DiaryEntry]
        let zoomLevel: Double
        
        var representativeEntry: DiaryEntry {
            // 返回日期最近的日记
            entries.sorted { $0.date > $1.date }.first!
        }
        
        var displayTitle: String {
            switch zoomLevel {
            case ...5: return representativeEntry.location.country
            case 5..<8: return representativeEntry.location.state
            case 8..<12: return representativeEntry.location.city
            default: return representativeEntry.location.street ?? representativeEntry.title
            }
        }
        
        var displayDate: String {
            let formatter = DateFormatter()
            switch zoomLevel {
            case ...5: 
                formatter.dateFormat = "yyyy"
            case 5..<8:
                formatter.dateFormat = "yyyy/MM"
            default:
                formatter.dateFormat = "yyyy/MM/dd"
            }
            return formatter.string(from: representativeEntry.date)
        }
    }
    
    func updateAnnotations(for region: MKCoordinateRegion) {
        // 计算当前缩放级别
        let span = region.span
        zoomLevel = log2(360 / span.longitudeDelta)
        
        // 根据缩放级别聚合数据
        mapAnnotations = clusterEntries(entries, zoomLevel: zoomLevel)
    }
    
    private func clusterEntries(_ entries: [DiaryEntry], zoomLevel: Double) -> [ClusteredAnnotation] {
        // 根据缩放级别确定聚合半径
        let clusterRadius: Double = switch zoomLevel {
            case ...5: 20 // 国家级别
            case 5..<8: 10 // 省级别
            case 8..<12: 5 // 市级别
            default: 0.5 // 街道级别
        }
        
        var clusters: [ClusteredAnnotation] = []
        var processedEntries = Set<UUID>()
        
        for entry in entries {
            if processedEntries.contains(entry.id) { continue }
            
            // 查找附的日记
            let nearbyEntries = entries.filter { nearby in
                !processedEntries.contains(nearby.id) &&
                isCoordinate(entry.location.coordinate,
                           near: nearby.location.coordinate,
                           radius: clusterRadius)
            }
            
            // 创建聚合标注
            let cluster = ClusteredAnnotation(
                coordinate: entry.location.coordinate,
                entries: nearbyEntries,
                zoomLevel: zoomLevel
            )
            
            clusters.append(cluster)
            nearbyEntries.forEach { processedEntries.insert($0.id) }
        }
        
        return clusters
    }
    
    private func isCoordinate(_ coord1: CLLocationCoordinate2D,
                            near coord2: CLLocationCoordinate2D,
                            radius: Double) -> Bool {
        let location1 = CLLocation(latitude: coord1.latitude,
                                 longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude,
                                 longitude: coord2.longitude)
        return location1.distance(from: location2) <= radius * 1000 // 转换为米
    }
    
    func loadInitialData() {
        entries = [
            DiaryEntry(
                title: "Maldives",
                date: Date(timeIntervalSince1970: 1513296000),
                location: DiaryEntry.Location(
                    coordinate: CLLocationCoordinate2D(latitude: 4.1755, longitude: 73.5093),
                    street: nil,
                    district: nil,
                    city: "Male",
                    state: "Male Province",
                    country: "Maldives"
                ),
                imageUrl: "maldives",
                content: "We took a plane in Charles de Gaulle airport in Paris to Male international airport, the flight lasted 13 hours and let me tell you that I loved it so much! It was the first time of my life that I took a long flight.\n\nI was able to see all the beautiful small islands. We arrived early in the afternoon so we had our first meal in the Ithaa Undersea Restaurant, it was delicious and really impressive to eat and see all",
                season: "Summer",
                year: "2017",
                duration: 8
            ),
            
            DiaryEntry(
                title: "Streets of Tokyo",
                date: Date(timeIntervalSince1970: 1583020800),
                location: DiaryEntry.Location(
                    coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
                    street: "Meiji Shrine",
                    district: "Shibuya",
                    city: "Tokyo",
                    state: "Tokyo Prefecture",
                    country: "Japan"
                ),
                imageUrl: "tokyo",
                content: "Exploring the streets of Harajuku today. The energy here is absolutely incredible! Started our morning at the serene Meiji Shrine, then dove into the colorful chaos of Takeshita Street. The contrast between traditional and modern Japan is fascinating...",
                season: "Spring",
                year: "2020",
                duration: 5
            ),
            
            DiaryEntry(
                title: "Afternoon at Eiffel Tower",
                date: Date(timeIntervalSince1970: 1588291200),
                location: DiaryEntry.Location(
                    coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
                    street: "Champ de Mars",
                    district: nil,
                    city: "Paris",
                    state: "Île-de-France",
                    country: "France"
                ),
                imageUrl: "paris",
                content: "Paris in spring is truly enchanting. Spent the afternoon picnicking at Champ de Mars, watching the Eiffel Tower sparkle as the sun set. The cherry blossoms are in full bloom, adding a magical touch to every corner of the city...",
                season: "Spring",
                year: "2020",
                duration: 3
            ),
            
            DiaryEntry(
                title: "Central Park Morning",
                date: Date(timeIntervalSince1970: 1593561600),
                location: DiaryEntry.Location(
                    coordinate: CLLocationCoordinate2D(latitude: 40.7829, longitude: -73.9654),
                    street: "Central Park West",
                    district: "Manhattan",
                    city: "New York",
                    state: "New York",
                    country: "United States"
                ),
                imageUrl: "nyc",
                content: "Found a peaceful spot in the bustling city. Started the day with a morning jog around the Jackie Onassis Reservoir, followed by breakfast at Belvedere Castle. It's amazing how Central Park can make you forget you're in the middle of Manhattan...",
                season: "Summer",
                year: "2020",
                duration: 4
            ),
            
            DiaryEntry(
                title: "Venice Canals",
                date: Date(timeIntervalSince1970: 1598918400),
                location: DiaryEntry.Location(
                    coordinate: CLLocationCoordinate2D(latitude: 45.4408, longitude: 12.3155),
                    street: "St. Mark's Square",
                    district: nil,
                    city: "Venice",
                    state: "Veneto",
                    country: "Italy"
                ),
                imageUrl: "venice",
                content: "Gliding through narrow canals on a gondola, watching the centuries-old buildings pass by. The afternoon light creates beautiful reflections on the water. Stopped for gelato near Rialto Bridge and watched the sunset from St. Mark's Square...",
                season: "Fall",
                year: "2020",
                duration: 6
            )
        ]
    }
}
