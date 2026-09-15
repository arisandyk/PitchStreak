import Foundation
import Core

public enum HomeFeatureFactory {
    public static func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(getTopSongsUseCase: GetTopSongsUseCaseImpl(repository: CoreDependencies.songRepository))
    }

    public static func makeSongDetailViewModel() -> SongDetailViewModel {
        SongDetailViewModel(
            toggleFavoriteSongUseCase: ToggleFavoriteSongUseCaseImpl(repository: CoreDependencies.songRepository),
            getFavoriteSongsUseCase: GetFavoriteSongsUseCaseImpl(repository: CoreDependencies.songRepository)
        )
    }
}
