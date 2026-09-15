import Foundation
import Combine
import RxSwift
import Core

public final class FavoriteViewModel: ObservableObject {
    @Published public var favorites: [FavoriteSong] = []
    @Published public var isLoading = false

    private let getFavoriteSongsUseCase: GetFavoriteSongsUseCase
    private let toggleFavoriteSongUseCase: ToggleFavoriteSongUseCase
    private let disposeBag = DisposeBag()

    public init(getFavoriteSongsUseCase: GetFavoriteSongsUseCase, toggleFavoriteSongUseCase: ToggleFavoriteSongUseCase) {
        self.getFavoriteSongsUseCase = getFavoriteSongsUseCase
        self.toggleFavoriteSongUseCase = toggleFavoriteSongUseCase
    }

    public func loadFavorites() {
        isLoading = true
        getFavoriteSongsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] favorites in
                self?.favorites = favorites
                self?.isLoading = false
            }, onError: { [weak self] _ in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }

    public func removeFavorite(_ favorite: FavoriteSong) {
        toggleFavoriteSongUseCase.execute(song: favorite.song, isCurrentlyFavorite: true)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.loadFavorites()
            })
            .disposed(by: disposeBag)
    }
}
