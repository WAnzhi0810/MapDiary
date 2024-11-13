//
//  ContentView.swift
//  MapDiary
//
//  Created by Zeno on 2024/11/13.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var viewMode: ViewMode = .list
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewMode == .list {
                    TripListView(entries: viewModel.entries)
                        .transition(.move(edge: .leading))
                } else {
                    TripMapView(viewModel: viewModel)
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.spring(response: 0.3), value: viewMode)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                CustomNavigationBar(title: "My Trips", viewMode: $viewMode)
            }
        }
        .onAppear {
            viewModel.loadInitialData()
        }
    }
}

// 视图模式枚举
enum ViewMode {
    case list
    case map
    
    mutating func toggle() {
        self = self == .list ? .map : .list
    }
}

#Preview {
    ContentView()
}
