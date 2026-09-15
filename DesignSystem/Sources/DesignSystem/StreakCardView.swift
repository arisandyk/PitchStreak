import SwiftUI
import Core

public struct StreakCardView: View {
    private let streak: Streak

    public init(streak: Streak) {
        self.streak = streak
    }

    public var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundStyle(.orange)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak.currentStreak) hari beruntun")
                    .font(.subheadline.weight(.semibold))
                Text("\(streak.totalSessionsThisWeek) sesi minggu ini")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
