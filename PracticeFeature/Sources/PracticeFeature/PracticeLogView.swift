import SwiftUI
import Combine
import Core
import DesignSystem

public struct PracticeLogView: View {
    @StateObject private var viewModel: PracticeLogViewModel
    @State private var showingTimer = false

    public init(viewModel: PracticeLogViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        StreakCardView(streak: viewModel.streak)
                            .listRowSeparator(.hidden)
                    }
                    Section("Riwayat latihan") {
                        ForEach(viewModel.sessions) { session in
                            NavigationLink(value: session) {
                                SessionRowView(session: session)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: PracticeSession.self) { session in
                    SessionDetailView(session: session, viewModel: PracticeFeatureFactory.makeSessionDetailViewModel())
                }
                .navigationTitle("Latihan")
                .overlay {
                    if viewModel.isLoading && viewModel.sessions.isEmpty {
                        ProgressView("Memuat sesi latihan...")
                    }
                }

                Button {
                    showingTimer = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.accentColor))
                        .shadow(radius: 4)
                }
                .padding()
            }
            .sheet(isPresented: $showingTimer, onDismiss: { viewModel.loadSessions() }) {
                TimerView(viewModel: PracticeFeatureFactory.makeTimerViewModel())
            }
        }
        .onAppear { viewModel.loadSessions() }
    }
}
