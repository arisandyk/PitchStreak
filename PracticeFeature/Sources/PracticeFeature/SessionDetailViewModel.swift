import Foundation
import Combine
import RxSwift
import Core

public final class SessionDetailViewModel: ObservableObject {
    @Published public var songUsageCount: Int?

    private let getFavoriteSongsUseCase: GetFavoriteSongsUseCase
    private let disposeBag = DisposeBag()

    public init(getFavoriteSongsUseCase: GetFavoriteSongsUseCase) {
        self.getFavoriteSongsUseCase = getFavoriteSongsUseCase
    }

    public func loadUsageCount(for songId: String?) {
        guard let songId = songId else { return }
        getFavoriteSongsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] favorites in
                self?.songUsageCount = favorites.first(where: { $0.id == songId })?.usageCount
            })
            .disposed(by: disposeBag)
    }
}
