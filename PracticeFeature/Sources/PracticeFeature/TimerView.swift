import SwiftUI
import Combine
import Core

public struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: TimerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Jenis latihan") {
                    Picker("Jenis", selection: $viewModel.selectedType) {
                        ForEach(PracticeType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    if let song = viewModel.selectedSong {
                        HStack(spacing: 12) {
                            AsyncImage(url: song.artworkURL) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(song.title).font(.subheadline.weight(.medium))
                                Text(song.artist).font(.caption).foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button("Ganti") {
                                viewModel.clearSelectedSong()
                            }
                            .font(.caption)
                        }
                    } else {
                        TextField("Cari lagu...", text: Binding(
                            get: { viewModel.searchQuery },
                            set: { viewModel.onSearchQueryChanged($0) }
                        ))
                        ForEach(viewModel.searchResults) { song in
                            Button {
                                viewModel.selectSong(song)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(song.title).foregroundStyle(.primary)
                                    Text(song.artist).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Lagu (opsional)")
                } footer: {
                    Text("Lagu yang kamu pilih otomatis masuk ke tab Favorit, sekalian ke-track berapa kali dipakai.")
                }

                Section {
                    VStack(spacing: 12) {
                        Text(formattedTime(viewModel.elapsedSeconds))
                            .font(.system(size: 40, weight: .medium, design: .monospaced))
                        Button {
                            viewModel.toggleTimer()
                        } label: {
                            Label(
                                viewModel.isRunning ? "Jeda" : "Mulai",
                                systemImage: viewModel.isRunning ? "pause.fill" : "play.fill"
                            )
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("Catatan") {
                    TextField("Catatan latihan hari ini...", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Sesi baru")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") { viewModel.saveSession() }
                        .disabled(viewModel.elapsedSeconds == 0)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
            }
            .onChange(of: viewModel.didSave) { _, saved in
                if saved { dismiss() }
            }
        }
    }

    private func formattedTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
