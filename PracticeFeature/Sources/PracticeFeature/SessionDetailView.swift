import SwiftUI
import Combine
import Core

public struct SessionDetailView: View {
    private let session: PracticeSession
    @StateObject private var viewModel: SessionDetailViewModel

    public init(session: PracticeSession, viewModel: SessionDetailViewModel) {
        self.session = session
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        List {
            if let song = session.song {
                Section {
                    HStack(spacing: 12) {
                        AsyncImage(url: song.artworkURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading) {
                            Text(song.title).font(.headline)
                            Text(song.artist).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Detail sesi") {
                LabeledContent("Jenis latihan", value: session.practiceType.displayName)
                LabeledContent("Durasi", value: formattedDuration(session.durationSeconds))
                LabeledContent("Tanggal", value: session.date.formatted(date: .abbreviated, time: .shortened))
                if let count = viewModel.songUsageCount {
                    LabeledContent("Lagu ini dipakai", value: "\(count)x")
                }
            }

            if let notes = session.notes, !notes.isEmpty {
                Section("Catatan") {
                    Text(notes)
                }
            }
        }
        .navigationTitle("Detail sesi")
        .onAppear { viewModel.loadUsageCount(for: session.song?.id) }
    }

    private func formattedDuration(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
