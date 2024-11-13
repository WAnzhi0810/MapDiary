import Foundation
import CoreLocation

// 日记数据模型
struct DiaryEntry: Identifiable {
    let id: UUID = UUID()
    let title: String
    let date: Date
    let location: Location
    let imageUrl: String
    let content: String
    let season: String
    let year: String
    let duration: Int
    
    struct Location {
        let coordinate: CLLocationCoordinate2D
        let street: String?
        let district: String?
        let city: String
        let state: String
        let country: String
    }
}
