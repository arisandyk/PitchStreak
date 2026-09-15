import SwiftUI
import Combine
import Core
import PracticeFeature

public struct SongDetailView: View {
    private let song: Song
    @StateObject private var viewModel: SongDetailViewModel
    @State private var showingTimer = false

    public init(song: Song, viewModel: SongDetailViewModel) {
        self.song = song
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    AsyncImage(url: song.artworkURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text(song.title).font(.title3.weight(.semibold)).multilineTextAlignment(.center)
                    Text(song.artist).font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowSeparator(.hidden)

            Section {
                Button {
                    viewModel.toggleFavorite(song: song)
                } label: {
                    Label(
                        viewModel.isFavorite ? "Hapus dari Favorit" : "Tambah ke Favorit",
                        systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                    )
                }

                if viewModel.usageCount > 0 {
                    LabeledContent("Dipakai buat latihan", value: "\(viewModel.usageCount)x")
                }

                Button {
                    showingTimer = true
                } label: {
                    Label("Mulai latihan dengan lagu ini", systemImage: "timer")
                }
            }
        }
        .navigationTitle("Detail lagu")
        .onAppear { viewModel.loadFavoriteState(for: song) }
        .sheet(isPresented: $showingTimer) {
            TimerView(viewModel: PracticeFeatureFactory.makeTimerViewModel(preselectedSong: song))
        }
    }
}
