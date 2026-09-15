import Foundation
import Core

public enum FavoriteFeatureFactory {
    public static func makeFavoriteViewModel() -> FavoriteViewModel {
        FavoriteViewModel(
            getFavoriteSongsUseCase: GetFavoriteSongsUseCaseImpl(repository: CoreDependencies.songRepository),
            toggleFavoriteSongUseCase: ToggleFavoriteSongUseCaseImpl(repository: CoreDependencies.songRepository)
        )
    }
}
