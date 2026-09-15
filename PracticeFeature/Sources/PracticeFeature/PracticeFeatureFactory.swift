import Foundation
import Core

public enum PracticeFeatureFactory {
    public static func makeTimerViewModel(preselectedSong: Song? = nil) -> TimerViewModel {
        TimerViewModel(
            searchSongUseCase: SearchSongUseCaseImpl(repository: CoreDependencies.songRepository),
            saveSessionUseCase: SaveSessionUseCaseImpl(
                sessionRepository: CoreDependencies.sessionRepository,
                songRepository: CoreDependencies.songRepository
            ),
            ensureSongFavoritedUseCase: EnsureSongFavoritedUseCaseImpl(repository: CoreDependencies.songRepository),
            preselectedSong: preselectedSong
        )
    }

    public static func makePracticeLogViewModel() -> PracticeLogViewModel {
        PracticeLogViewModel(
            getSessionsUseCase: GetSessionsUseCaseImpl(repository: CoreDependencies.sessionRepository),
            calculateStreakUseCase: CalculateStreakUseCaseImpl()
        )
    }

    public static func makeSessionDetailViewModel() -> SessionDetailViewModel {
        SessionDetailViewModel(
            getFavoriteSongsUseCase: GetFavoriteSongsUseCaseImpl(repository: CoreDependencies.songRepository)
        )
    }
}
