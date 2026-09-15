import SwiftUI
import Combine

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    public init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        // Nama asset ini ada di Assets.xcassets milik App target (main bundle),
                        // jadi tetap ketemu meski View-nya sekarang tinggal di module terpisah.
                        Image("profile_photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ari Sandy Kurniawan")
                                .font(.headline)
                            Text("Developer PitchStreak")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Statistik") {
                    LabeledContent("Streak terpanjang", value: "\(viewModel.longestStreak) hari")
                }

                Section("Tentang aplikasi") {
                    Text("PitchStreak membantu memantau latihan vokal harian, mingguan, dan bulanan lengkap dengan pencatatan lagu yang dipakai.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profil")
        }
        .onAppear { viewModel.loadStats() }
    }
}
