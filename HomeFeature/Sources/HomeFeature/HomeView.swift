import SwiftUI
import Combine
import Core
import DesignSystem

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            List(viewModel.songs) { song in
                NavigationLink(value: song) {
                    SongRowView(song: song)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Song.self) { song in
                SongDetailView(song: song, viewModel: HomeFeatureFactory.makeSongDetailViewModel())
            }
            .navigationTitle("Top Chart")
            .overlay {
                if viewModel.isLoading && viewModel.songs.isEmpty {
                    ProgressView("Memuat chart lagu...")
                } else if let error = viewModel.errorMessage, viewModel.songs.isEmpty {
                    ContentUnavailableView(error, systemImage: "wifi.slash")
                }
            }
        }
        .onAppear {
            if viewModel.songs.isEmpty { viewModel.loadTopSongs() }
        }
    }
}
