import SwiftUI
import Core

public struct SongRowView: View {
    private let song: Song

    public init(song: Song) {
        self.song = song
    }

    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: song.artworkURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.15)
                    .overlay(Image(systemName: "music.note").foregroundStyle(.secondary))
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title).font(.subheadline.weight(.medium))
                Text(song.artist).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
