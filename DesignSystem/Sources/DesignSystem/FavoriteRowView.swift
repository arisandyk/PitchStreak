import SwiftUI
import Core

public struct FavoriteRowView: View {
    private let favorite: FavoriteSong

    public init(favorite: FavoriteSong) {
        self.favorite = favorite
    }

    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: favorite.song.artworkURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.15)
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(favorite.song.title).font(.subheadline.weight(.medium))
                Text(favorite.song.artist).font(.caption).foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(favorite.usageCount)x")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.15))
                .clipShape(Capsule())
        }
    }
}
