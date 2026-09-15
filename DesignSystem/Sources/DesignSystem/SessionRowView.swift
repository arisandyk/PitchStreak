import SwiftUI
import Combine
import Core

public struct SessionRowView: View {
    private let session: PracticeSession

    public init(session: PracticeSession) {
        self.session = session
    }

    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: session.song?.artworkURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.15)
                    .overlay(Image(systemName: "music.note").foregroundStyle(.secondary))
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(session.song?.title ?? session.practiceType.displayName)
                    .font(.subheadline.weight(.medium))
                Text("\(session.practiceType.displayName) · \(session.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(formattedDuration(session.durationSeconds))
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    private func formattedDuration(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
