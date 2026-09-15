import Foundation
import Combine
import RxSwift
import Core

public final class SongDetailViewModel: ObservableObject {
    @Published public var isFavorite = false
    @Published public var usageCount: Int = 0

    private let toggleFavoriteSongUseCase: ToggleFavoriteSongUseCase
    private let getFavoriteSongsUseCase: GetFavoriteSongsUseCase
    private let disposeBag = DisposeBag()

    public init(toggleFavoriteSongUseCase: ToggleFavoriteSongUseCase, getFavoriteSongsUseCase: GetFavoriteSongsUseCase) {
        self.toggleFavoriteSongUseCase = toggleFavoriteSongUseCase
        self.getFavoriteSongsUseCase = getFavoriteSongsUseCase
    }

    public func loadFavoriteState(for song: Song) {
        getFavoriteSongsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] favorites in
                if let match = favorites.first(where: { $0.id == song.id }) {
                    self?.isFavorite = true
                    self?.usageCount = match.usageCount
                } else {
                    self?.isFavorite = false
                    self?.usageCount = 0
                }
            })
            .disposed(by: disposeBag)
    }

    public func toggleFavorite(song: Song) {
        toggleFavoriteSongUseCase.execute(song: song, isCurrentlyFavorite: isFavorite)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.isFavorite.toggle()
            })
            .disposed(by: disposeBag)
    }
}
